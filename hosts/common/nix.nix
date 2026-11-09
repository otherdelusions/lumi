{ inputs, lib, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      accept-flake-config = true;
      auto-optimise-store = true;
      warn-dirty = false;
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
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
