{ den, ... }:
{
  den.aspects.dev.helix.includes = [ den.aspects.dev.helix.languages ];

  den.aspects.dev.helix.languages = {
    homeManager = {
      programs.helix.languages = {
        language-server = {
          gopls.config = {
            gofumpt = true;
            "ui.diagnostic.staticcheck" = true;
          };
        };

        language = [
          {
            name = "github-action";
            auto-format = true;
            formatter.command = "yamlfmt";
            formatter.args = [ "-" ];
          }
        ];
      };
    };
  };
}
