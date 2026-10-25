{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "hm-backup";
    extraSpecialArgs = { inherit inputs; };
    users.ferret = import ../home/ferret;
  };

  security.nix-secrets = {
    identityPaths = [ "/home/ferret/keys.txt" ];
    recipientAliases.ferret = "age1g6flkq5k0kqxy2y7fdk5ttpzjp6t0d7yz47h0p2mnvuu7we8x3fsa4m5m0";
    secrets."ssh_keys/to_github" = {
      recipients = [ "ferret" ];
      owner = "ferret";
    };
  };
}
