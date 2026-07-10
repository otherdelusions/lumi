{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = {
    treefmt.config = {
      flakeCheck = false;

      programs = {
        deadnix.enable = true;
        statix.enable = true;
        nixfmt.enable = true;
        yamlfmt.enable = true;
      };

      settings.formatter = {
        deadnix.priority = 1;
        statix.priority = 2;
        nixfmt.priority = 3;
      };
    };
  };
}
