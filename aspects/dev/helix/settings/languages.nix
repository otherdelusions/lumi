{ den, ... }:
{
  den.aspects.dev.helix.includes = [ den.aspects.dev.helix.languages ];

  den.aspects.dev.helix.languages = {
    homeManager = { ... }: {
      programs.helix.languages = {
        language-server = {
          gopls.config = {
            gofumpt = true;
            staticcheck = true;
          };

          nixd.config.nixd.formatting.command = [ "nixfmt" ];
        };

        language = [
          {
            name = "nix";
            language-servers = [ "nixd" ];
            auto-format = true;
            formatter.command = "nixfmt";
          }
          {
            name = "go";
            language-servers = [ "gopls" ];
            auto-format = true;
          }
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
