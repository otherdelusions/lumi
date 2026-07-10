{ den, ... }:
{
  den.aspects.browser.librewolf.includes = [ den.aspects.browser.librewolf.extensions ];

  den.aspects.browser.librewolf.extensions = {
    nixos =
      let
        mkInstallUrl = id: "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      in
      {
        programs.librewolf.policies.ExtensionSettings =
          let
            defaults = {
              installation_mode = "force_installed";
              default_area = "addon-bar";
            };
          in
          {
            "uBlock0@raymondhill.net" = defaults // {
              install_url = mkInstallUrl "ublock-origin";
            };
          };
      };
  };
}
