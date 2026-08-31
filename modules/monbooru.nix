{
  flake.nixosModules.monbooru =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (lib)
        mkOption
        mkEnableOption
        mkPackageOption
        mkIf
        literalExpression
        getExe
        toInt
        last
        splitString
        ;

      inherit (lib.types)
        strMatching
        path
        externalPath
        str
        listOf
        submodule
        nullOr
        bool
        ;

      cfg = config.services.monbooru;
      settingsFormat = pkgs.formats.toml { };
      configFile = "${cfg.dataDir}/monbooru.toml";
      hasPassword = cfg.passwordFile != null;

      galleryOpts = _: {
        options = {
          name = mkOption {
            type = strMatching "[A-Za-z0-9_-]+";
            example = "default";
            description = "Gallery name.";
          };
          gallery_path = mkOption {
            type = externalPath;
            example = "/srv/monbooru/gallery";
            description = "Filesystem gallery root.";
          };
        };
      };
    in
    {
      options.services.monbooru = {
        enable = mkEnableOption "monbooru booru-style gallery";

        package = mkPackageOption pkgs "monbooru" { };

        dataDir = mkOption {
          type = externalPath;
          default = "/var/lib/monbooru";
          description = "Data directory holding 'monbooru.toml', databases, plugins and themes.";
        };

        user = mkOption {
          type = str;
          default = "monbooru";
          description = "User under which monbooru runs.";
        };

        group = mkOption {
          type = str;
          default = "monbooru";
          description = "Group under which monbooru runs.";
        };

        openFirewall = mkOption {
          type = bool;
          default = false;
          example = true;
          description = "Whether to open the port specified in bind_address in the firewall.";
        };

        timeZone = mkOption {
          type = str;
          default = "UTC";
          example = "America/New_York";
          description = "Time zone monbooru will reference.";
        };

        passwordFile = mkOption {
          type = nullOr path;
          default = null;
          example = "/run/secrets/monbooru-password";
          description = ''
            Path to a file containing a plaintext web UI password.
            Password is hashed at service start and passed via 'MONBOORU_AUTH_PASSWORD_HASH'
          '';
        };

        settings = mkOption {
          default = { };
          example = literalExpression ''
            {
              server.monloader_url = "http://localhost:9000";
              auth.session_lifetime_days = 30;
              log.level = "info";
            }
          '';
          description = ''
            Settings written to 'monbooru.toml'.
            Refer to https://monbooru.github.io/mondocs/configuration.html#monboorutoml for supported values.
          '';
          type = submodule {
            freeformType = settingsFormat.type;

            options = {
              default_gallery = mkOption {
                type = str;
                default = if cfg.settings.galleries != [ ] then (builtins.head cfg.settings.galleries).name else "";
                defaultText = literalExpression "(builtins.head cfg.settings.galleries).name";
                example = "default";
                description = "Name of gallery selected by default";
              };

              galleries = mkOption {
                type = listOf (submodule galleryOpts);
                default = [
                  {
                    name = "default";
                    gallery_path = "/var/lib/monbooru/gallery";
                  }
                ];
                example = literalExpression ''
                  [
                    { name = "default"; gallery_path = "/srv/monbooru/gallery"; }
                    { name = "art"; gallery_path = "/srv/monbooru/art"; }
                  ]
                '';
                description = "Named galleries to index.";
              };

              server = {
                bind_address = mkOption {
                  type = str;
                  default = "127.0.0.1:8080";
                  example = "0.0.0.0:8080";
                  description = "Listen address:port";
                };

                base_url = mkOption {
                  type = str;
                  default = "http://localhost:8080";
                  example = "https://monbooru.example.com";
                  description = "Base URL monbooru uses.";
                };
              };

              paths = {
                data_path = mkOption {
                  type = externalPath;
                  default = "${cfg.dataDir}/data";
                  defaultText = literalExpression ''"''${cfg.dataDir}/data"'';
                  example = "/var/lib/monbooru/data";
                  description = "Databases and thumbnails path";
                };

                model_path = mkOption {
                  type = externalPath;
                  default = "${cfg.dataDir}/models";
                  defaultText = literalExpression ''"''${cfg.dataDir}/models"'';
                  example = "/var/lib/monbooru/models";
                  description = "Auto-tagger models path";
                };
              };
            };
          };
        };
      };

      config = mkIf cfg.enable {
        assertions = [
          {
            assertion =
              !cfg.openFirewall || (builtins.match "^.+:[0-9]+$" cfg.settings.server.bind_address != null);
            message = "services.monbooru.openFirewall requires services.monbooru.settings.server.bind_address to be in \"host:port\" form.";
          }
        ];

        systemd = {
          tmpfiles.settings.monbooruDirs = {
            "${cfg.dataDir}"."d" = {
              mode = "750";
              inherit (cfg) user group;
            };
          };

          services.monbooru = {
            description = "monbooru image gallery";
            wantedBy = [ "multi-user.target" ];
            after = [ "network.target" ];
            wants = [ "network.target" ];

            preStart = ''
              set -e
              install -m600 -o "${cfg.user}" -g "${cfg.group}" \
                "${settingsFormat.generate "monbooru.toml" cfg.settings}" \
                "${configFile}"
            ''
            + lib.optionalString hasPassword ''
              HASH=$(${getExe cfg.package} -hash-password "$(cat "${cfg.passwordFile}")")
              install -m600 -o "${cfg.user}" -g "${cfg.group}" /dev/null "$RUNTIME_DIRECTORY/auth-env"
              {
                printf 'MONBOORU_AUTH_ENABLE_PASSWORD=true\n'
                printf 'MONBOORU_AUTH_PASSWORD_HASH=%s\n' "$HASH"
              } > "$RUNTIME_DIRECTORY/auth-env"
            '';

            serviceConfig = {
              Type = "simple";
              User = cfg.user;
              Group = cfg.group;
              WorkingDirectory = cfg.dataDir;
              ExecStart = "${getExe cfg.package} -config ${configFile}";
              Restart = "on-failure";
              RestartSec = "5s";

              RuntimeDirectory = "monbooru";
              RuntimeDirectoryMode = "0750";

              EnvironmentFile = mkIf hasPassword "-%t/monbooru/auth-env";
              Environment = [
                "TZ=${cfg.timeZone}"
              ];

              UMask = "0027";

              ReadWritePaths = [
                cfg.dataDir
                cfg.settings.paths.data_path
                cfg.settings.paths.model_path
              ]
              ++ map (g: g.gallery_path) cfg.settings.galleries;

              CapabilityBoundingSet = [
                "CAP_CHOWN"
                "CAP_DAC_OVERRIDE"
              ];
              AmbientCapabilities = [
                "CAP_CHOWN"
                "CAP_DAC_OVERRIDE"
              ];

              NoNewPrivileges = true;

              ProtectSystem = "strict";
              ProtectHostname = true;
              ProtectClock = true;
              ProtectKernelTunables = true;
              ProtectKernelModules = true;
              ProtectKernelLogs = true;
              ProtectControlGroups = true;
              ProcSubset = "pid";
              ProtectProc = "invisible";

              RestrictNamespaces = true;
              LockPersonality = true;
              RestrictRealtime = true;
              RemoveIPC = true;
              PrivateMounts = true;

              SystemCallArchitectures = "native";
            };
          };
        };

        networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [
          (toInt (last (splitString ":" cfg.settings.server.bind_address)))
        ];

        users.users = mkIf (cfg.user == "monbooru") {
          monbooru = {
            inherit (cfg) group;
            isSystemUser = true;
          };
        };

        users.groups = mkIf (cfg.group == "monbooru") { monbooru = { }; };
      };
    };
}
