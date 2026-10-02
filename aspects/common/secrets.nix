{ den, inputs, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.secrets ];

  den.aspects.common.secrets = {
    nixos = {
      imports = [
        inputs.nix-secrets.nixosModules.default
      ];

      security.nix-secrets = {
        enable = true;
        storage = ../../secrets;
      };
    };
  };
}
