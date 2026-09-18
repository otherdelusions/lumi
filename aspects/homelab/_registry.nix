{ lib, ... }:
let
  inherit (lib) mkOption;

  inherit (lib.types)
    str
    submodule
    attrsOf
    ;

  type = attrsOf (submodule {
    options = {
      description = mkOption {
        type = str;
        default = "";
        example = "useful service";
        description = "Short registry entry description. Must be lowercase.";
      };
      iconUrl = mkOption {
        type = str;
        default = "";
        example = "https://example.com/icon.png";
        description = "Registry entry icon URL";
      };
      path = mkOption {
        type = str;
        default = "";
        example = "modules/homelab/service.nix";
        description = "Path to nix file, relative to flake root, declaring the registry entry.";
      };
    };
  });
in
{
  options.flake.homelabServices = mkOption {
    inherit type;
    default = { };
  };

  options.flake.homelabContainers = mkOption {
    inherit type;
    default = { };
  };
}
