# nixos user setup
{
  lib,
  pkgs,
  ...
}:
{
  users.users.ferret = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];

    shell = pkgs.fish;
    initialPassword = lib.mkDefault "changeme";
  };

  programs.fish.enable = true;

  security.nix-secrets = {
    identityPaths = [ "/home/ferret/keys.txt" ];
    recipientAliases.ferret = "age1g6flkq5k0kqxy2y7fdk5ttpzjp6t0d7yz47h0p2mnvuu7we8x3fsa4m5m0";

    # secrets shared across hosts
    secrets."ssh_keys/to_github" = {
      recipients = [ "ferret" ];
      owner = "ferret";
    };
  };
}
