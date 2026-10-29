{ den, ... }:
{
  flake.homelabServices.opencloud = {
    description = "personal and shared cloud storage";
    iconUrl = "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/opencloud.png";
    path = "aspects/homelab/services/opencloud.nix";
  };

  den.aspects.homelab.services.opencloud = {
    includes = [
      den.aspects.homelab.services
      (den.batteries.unfree [
        "corefonts"
        "vista-fonts"
      ])
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        inherit (lib)
          mkOption
          mkDefault
          mkEnableOption
          mkIf
          mkMerge
          optionals
          literalExpression
          ;

        inherit (lib.types)
          externalPath
          port
          attrsOf
          nullOr
          path
          package
          ;

        hl = config.homelab;
        cfg = hl.services.opencloud;
        serviceCfg = config.services.opencloud;

        euroOfficeUrl = "https://${hl.baseDomain}:${toString cfg.euroOffice.port}";
      in
      {
        options.homelab.services.opencloud = {
          dataDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.data}/services/opencloud";
            example = "/var/lib/opencloud";
            description = "OpenCloud data directory.";
          };

          storageDir = mkOption {
            type = externalPath;
            default = "${hl.dirs.content}/opencloud";
            example = "/srv/opencloud";
            description = "OpenCloud file storage directory.";
          };

          port = mkOption {
            type = port;
            default = 9200;
            example = 9090;
            description = "OpenCloud service port.";
          };

          settings = mkOption {
            type = attrsOf (pkgs.formats.yaml { }).type;
            default = { };
            example = literalExpression ''
              {
                proxy.loglevel = "info";
                graph.spaces.default_quota = "10000000000";
              }
            '';
            description = "Additional OpenCloud settings.";
          };

          apps = mkOption {
            type = attrsOf package;
            default = { };
            example = literalExpression ''
              {
                calculator = pkgs.fetchzip {
                  url = "https://github.com/opencloud-eu/web-extensions/releases/download/calculator-v2.1.0/calculator-2.1.0.zip";
                  hash = "sha256-fm5r2THXdwklsEqblCbtBlWhzvUknQtGs0CoE9WFu1A=";
                };
              }
            '';
            description = "Compiled OpenCloud apps, usually zip files, keyed by their app ID.";
          };

          euroOffice = {
            enable = mkEnableOption "Euro Office on the next port after OpenCloud.";
            useMSFonts = mkEnableOption "Use Microsoft's unfree fonts on Euro Office.";
            port = mkOption {
              type = port;
              default = 9201;
              example = 9091;
              description = "Euro Office service port.";
            };
          };

          environmentFile = mkOption {
            type = nullOr path;
            default = null;
            description = "Runtime environment file for secrets.";
          };
        };

        config = mkMerge [
          {
            services.opencloud = {
              enable = true;
              stateDir = cfg.dataDir;
              address = mkDefault "0.0.0.0";
              url = mkDefault "https://${hl.baseDomain}:${toString cfg.port}";

              inherit (cfg) port settings environmentFile;

              environment = {
                OC_INSECURE = mkDefault "true";
                STORAGE_USERS_POSIX_ROOT = cfg.storageDir;
                WEB_ASSET_APPS_PATH = "${pkgs.linkFarm "opencloud-apps" cfg.apps}";
              };
            };

            networking.firewall.allowedTCPPorts = [ serviceCfg.port ];

            systemd = {
              tmpfiles.settings.homelab-opencloud."${cfg.storageDir}".d = {
                mode = "0700";
                inherit (serviceCfg) user group;
              };

              services.opencloud = {
                unitConfig.RequiresMountsFor = [
                  cfg.dataDir
                  cfg.storageDir
                ];
                serviceConfig = {
                  ReadWritePaths = [ cfg.storageDir ];
                  RestrictAddressFamilies = [ "AF_NETLINK" ];
                };
              };
            };
          }

          (mkIf cfg.euroOffice.enable {
            services.opencloud.environment = {
              OC_ADD_RUN_SERVICES = "collaboration";
              COLLABORATION_WOPI_SRC = serviceCfg.url;
              COLLABORATION_APP_NAME = "EuroOffice";
              COLLABORATION_APP_PRODUCT = "OnlyOffice";
              COLLABORATION_APP_ADDR = euroOfficeUrl;
              COLLABORATION_APP_INSECURE = "true";
              COLLABORATION_CS3API_DATAGATEWAY_INSECURE = "true";
              COLLABORATION_APP_PROOF_DISABLE = "true";
              PROXY_CSP_CONFIG_FILE_LOCATION = "/etc/opencloud/csp.yaml";
            };

            homelab.services.opencloud.settings = {
              csp.directives.frame-src = [ euroOfficeUrl ]; # add eurooffice to security policy

              app-registry.app_registry.mimetypes = [
                {
                  extension = "docx";
                  mime_type = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                  name = "Word";
                  default_app = "EuroOffice";
                  allow_creation = true;
                }
                {
                  extension = "xlsx";
                  mime_type = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                  name = "Excel";
                  default_app = "EuroOffice";
                  allow_creation = true;
                }
                {
                  extension = "pptx";
                  mime_type = "application/vnd.openxmlformats-officedocument.presentationml.presentation";
                  name = "PowerPoint";
                  default_app = "EuroOffice";
                  allow_creation = true;
                }
              ];
            };

            virtualisation.oci-containers = {
              backend = "podman";

              containers.euro-office = {
                image = "ghcr.io/euro-office/documentserver:v9.3.7@sha256:39c4cdad8c335d05ea5653926e1fc3a69da006d9c1729936b2b4193140cd2962";
                ports = [ "${serviceCfg.address}:${toString cfg.euroOffice.port}:443" ];

                environment = {
                  WOPI_ENABLED = "true";
                  ALLOW_PRIVATE_IP_ADDRESS = "true";
                  USE_UNAUTHORIZED_STORAGE = "true";
                  SSL_CERTIFICATE_PATH = "/run/opencloud-tls/server.crt";
                  SSL_KEY_PATH = "/run/opencloud-tls/server.key";
                };

                volumes = [
                  "${cfg.dataDir}/proxy:/run/opencloud-tls:ro"
                  "euro-office-data:/var/www/euro-office/Data"
                  "euro-office-cache:/var/lib/euro-office"
                  "euro-office-postgresql:/var/lib/postgresql"
                ]
                ++ optionals cfg.euroOffice.useMSFonts [
                  "${pkgs.corefonts}/share/fonts/truetype:/usr/share/fonts/corefonts:ro"
                  "${pkgs.vista-fonts}/share/fonts/truetype:/usr/share/fonts/vista:ro"
                ];

                extraOptions = [ "--add-host=${hl.baseDomain}:host-gateway" ];
              };
            };

            systemd.services.podman-euro-office = {
              wants = [ "opencloud.service" ];
              after = [ "opencloud.service" ];

              unitConfig.RequiresMountsFor = [ cfg.dataDir ];

              serviceConfig = {
                ExecStartPre = [
                  "${pkgs.coreutils}/bin/test -s ${cfg.dataDir}/proxy/server.crt"
                  "${pkgs.coreutils}/bin/test -s ${cfg.dataDir}/proxy/server.key"
                ];
                RestartSec = "10s";
              };
            };
          })
        ];
      };
  };
}
