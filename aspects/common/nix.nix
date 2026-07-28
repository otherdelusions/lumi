{ den, inputs, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.nix ];

  den.aspects.common.nix = {
    nixos =
      { lib, config, ... }:
      {
        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];

            accept-flake-config = true;
            auto-optimise-store = true;
            warn-dirty = false;
            connect-timeout = lib.mkDefault 5;
            fallback = true;
            builders-use-substitutes = true;
            trusted-users = [ "@wheel" ];
          };

          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
          };

          channel.enable = lib.mkDefault false;
          optimise.automatic = lib.mkDefault (!config.boot.isContainer);

          nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
        };
      };
  };
}
