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
    escapeShellArgs
    mapAttrs'
    ;

  inherit (lib.types) listOf str attrsOf;

  cfg = config.programs.helium;
  prefsFormat = pkgs.formats.json { };
  prefsFile = prefsFormat.generate "helium-preferences.json" cfg.preferences;
in
{
  options.programs.helium = {
    enable = mkEnableOption "Helium browser";

    package = mkPackageOption pkgs "helium" {
      extraDescription = "The package must accept 'commandLineArgs' override so flags can be passed to it";
    };

    commandLineArgs = mkOption {
      type = listOf str;
      default = [ ];
      example = [
        "--ozone-platform=wayland"
        "--force-dark-mode"
        "--start-maximized"
      ];
      description = "Flags passed to Helium";
    };

    extensions = mkOption {
      type = attrsOf prefsFormat.type;
      default = { };
      example = {
        "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" = {
          external_crx = "/path/to/extension.crx";
          external_version = "1.0";
        };
      };
      description = ''
        External extension configuration
        Refer to https://developer.chrome.com/docs/extensions/how-to/distribute/install-extensions for reference
      '';
    };

    preferences = mkOption {
      type = attrsOf prefsFormat.type;
      default = { };
      example = {
        homepage = "https://example.com";
        browser.show_home_button = true;
        download.prompt_for_download = true;
      };
      description = ''
        Preferences merged into the default profile on activation
        Refer to https://raw.githubusercontent.com/chromium/chromium/main/chrome/common/pref_names.h for common preferences
        Refer to https://github.com/imputnet/helium/tree/main/patches/helium for Helium preferences
      '';
    };
  };

  config = mkIf cfg.enable {
    # only Default profile can be configured using this module
    # so we might as well force-load it on startup
    programs.helium.commandLineArgs = [ "--profile-directory=Default" ];

    home.packages = [
      (cfg.package.override { commandLineArgs = escapeShellArgs cfg.commandLineArgs; })
    ];

    xdg.configFile = mapAttrs' (id: settings: {
      name = "net.imput.helium/External Extensions/${id}.json";
      value.text = builtins.toJSON settings;
    }) cfg.extensions;

    # scuffed prefs merge
    home.activation.helium = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      prefs="${config.xdg.configHome}/net.imput.helium/Default/Preferences"
      if [ -f "$prefs" ]; then
        run ${lib.getExe pkgs.jaq} --in-place --slurpfile nix "${prefsFile}" \
          '. * $nix[0]' "$prefs"
      else
        run install -dm700 "$(dirname "$prefs")"
        run install -m600 "${prefsFile}" "$prefs"
      fi
    '';
  };
}
