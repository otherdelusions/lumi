{ inputs, ... }:
{
  imports = [ inputs.nix-secrets.nixosModules.default ];

  security.nix-secrets = {
    enable = true;
    storage = ../../secrets;
  };
}
