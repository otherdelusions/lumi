{ den, inputs, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.niri ];

  den.aspects.tiling-wm.niri = {
    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        imports = [ inputs.niri.nixosModules.niri ];

        nixpkgs.overlays = [ inputs.niri.overlays.niri ];

        programs.niri = {
          enable = true;
          package = pkgs.niri-unstable;
        };

        services.gnome.gcr-ssh-agent.enable = false;

        environment.systemPackages = lib.optionals config.programs.niri.enable [
          pkgs.xwayland-satellite
          pkgs.wl-clipboard
        ];
      };
  };
}
