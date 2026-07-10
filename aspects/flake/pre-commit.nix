{ inputs, ... }:
{
  imports = [ inputs.git-hooks.flakeModule ];

  perSystem =
    { config, ... }:
    {
      pre-commit.settings.hooks = {
        actionlint.enable = true;

        treefmt = {
          enable = true;
          package = config.treefmt.build.wrapper;
        };

        markdownlint = {
          enable = true;
          settings.configuration = {
            MD013 = false;
            MD033 = false;
          };
        };

        convco.enable = true;
      };
    };
}
