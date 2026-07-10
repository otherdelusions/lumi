{ lib, ... }:
let
  type = lib.types.attrsOf (
    lib.types.submodule {
      options = {
        description = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        iconUrl = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
        path = lib.mkOption {
          type = lib.types.str;
          default = "";
        };
      };
    }
  );
in
{
  options.flake.homelabServices = lib.mkOption {
    inherit type;
    default = { };
  };

  options.flake.homelabContainers = lib.mkOption {
    inherit type;
    default = { };
  };
}
