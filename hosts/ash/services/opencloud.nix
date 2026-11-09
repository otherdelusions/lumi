{
  homelab,
  config,
  lib,
  pkgs,
  ...
}:
let
  stateDir = "${homelab.dirs.data}/services/opencloud";
  officePort = 4902;
  serviceCfg = config.services.opencloud;
  officeUrl = "https://${homelab.baseDomain}:${toString officePort}";
in
{

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "corefonts"
      "vista-fonts"
    ];

  services.opencloud.environmentFile =
    config.security.nix-secrets.secrets."services/opencloud/ferret_pass".path;

  security.nix-secrets.secrets."services/opencloud/ferret_pass" = {
    recipients = [ "ash" ];
    owner = serviceCfg.user;
  };

  networking.firewall.allowedTCPPorts = [ serviceCfg.port ];

  virtualisation.oci-containers = {
    backend = "podman";

    containers.euro-office = {
      image = "ghcr.io/euro-office/documentserver:v9.3.7@sha256:39c4cdad8c335d05ea5653926e1fc3a69da006d9c1729936b2b4193140cd2962";
      ports = [ "${serviceCfg.address}:${toString officePort}:443" ];

      environment = {
        WOPI_ENABLED = "true";
        ALLOW_PRIVATE_IP_ADDRESS = "true";
        USE_UNAUTHORIZED_STORAGE = "true";
        SSL_CERTIFICATE_PATH = "/run/opencloud-tls/server.crt";
        SSL_KEY_PATH = "/run/opencloud-tls/server.key";
      };

      volumes = [
        "${stateDir}/proxy:/run/opencloud-tls:ro"
        "euro-office-data:/var/www/euro-office/Data"
        "euro-office-cache:/var/lib/euro-office"
        "euro-office-postgresql:/var/lib/postgresql"

        "${pkgs.corefonts}/share/fonts/truetype:/usr/share/fonts/corefonts:ro"
        "${pkgs.vista-fonts}/share/fonts/truetype:/usr/share/fonts/vista:ro"
      ];

      extraOptions = [ "--add-host=${homelab.baseDomain}:host-gateway" ];
    };
  };

  services.opencloud = {
    enable = true;
    package = pkgs.opencloud;
    inherit stateDir;
    inherit (homelab) address;
    port = 4901;
    url = "https://${homelab.baseDomain}:${toString serviceCfg.port}";

    environment = {
      OC_INSECURE = "true";
      STORAGE_USERS_POSIX_ROOT = "/srv/opencloud";
      OC_ADD_RUN_SERVICES = "collaboration";
      COLLABORATION_WOPI_SRC = serviceCfg.url;
      COLLABORATION_APP_NAME = "EuroOffice";
      COLLABORATION_APP_PRODUCT = "OnlyOffice";
      COLLABORATION_APP_ADDR = officeUrl;
      COLLABORATION_APP_INSECURE = "true";
      COLLABORATION_CS3API_DATAGATEWAY_INSECURE = "true";
      COLLABORATION_APP_PROOF_DISABLE = "true";
      PROXY_CSP_CONFIG_FILE_LOCATION = "/etc/opencloud/csp.yaml";
    };

    settings = {
      web.web.config.options = {
        disableSponsorLink = true;
        disableFeedbackLink = true;
      };

      frontend.archiver.max_size = 10737418240;
      storage-users.drivers.posix.personalspacepath_template = "users/{{.User.Username}}";
      csp.directives.frame-src = [ officeUrl ]; # add eurooffice to security policy

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
  };

  systemd = {
    tmpfiles.settings.opencloud."/srv/opencloud".d = {
      mode = "0700";
      inherit (serviceCfg) user group;
    };

    services.opencloud = {
      unitConfig.RequiresMountsFor = [
        stateDir
        "/srv/opencloud"
      ];

      serviceConfig = {
        ReadWritePaths = [ "/srv/opencloud" ];
        RestrictAddressFamilies = [ "AF_NETLINK" ];
      };
    };

    services.podman-euro-office = {
      wants = [ "opencloud.service" ];
      after = [ "opencloud.service" ];

      unitConfig.RequiresMountsFor = [ stateDir ];

      serviceConfig = {
        ExecStartPre = [
          "${pkgs.coreutils}/bin/test -s ${stateDir}/proxy/server.crt"
          "${pkgs.coreutils}/bin/test -s ${stateDir}/proxy/server.key"
        ];
        RestartSec = "10s";
      };
    };
  };
}
