{ lib, ... }:
{
  # All normal users on Ash can manage its shared media.
  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { config, ... }: {
          extraGroups = lib.mkIf config.isNormalUser [ "homelab" ];
        }
      )
    );
  };
}
