{ den, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.nautilus ];

  den.aspects.tiling-wm.nautilus = {
    nixos =
      {
        host,
        pkgs,
        lib,
        ...
      }:
      let
        terminal = host.desktop.terminal;
      in
      {
        environment.systemPackages = with pkgs; [
          nautilus
          ffmpegthumbnailer
        ];

        services.gvfs.enable = true;

        programs.nautilus-open-any-terminal = lib.mkIf (terminal != null) {
          enable = lib.mkDefault true;
          inherit terminal;
        };
      };

    homeManager =
      { lib, config, ... }:
      {
        xdg.userDirs.enable = lib.mkDefault true;
        xdg.userDirs.setSessionVariables = lib.mkDefault true;

        home.file =
          let
            inherit (config.xdg.userDirs) templates;
          in
          {
            "${templates}/Empty Text.txt".text = "";
          };
      };
  };
}
