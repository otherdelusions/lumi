{ lib, ... }:
{
  den.schema.host.options.desktop = {
    terminal = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "The terminal emulator this host uses (if it uses any)";
    };
  };

  den.schema.user.classes = lib.mkDefault [ "homeManager" ]; # set up HM and import user aspect's HM class
}
