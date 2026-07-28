{ den, ... }:
{
  den.aspects.dev.helix.includes = [ den.aspects.dev.helix.languages ];

  den.aspects.dev.helix.languages = {
    homeManager = { host, ... }: {
      programs.helix.languages =
        let
          flake = "(builtins.getFlake (builtins.toString ./.))";
          hmExpr = "${nixosExpr}.home-manager.users.type.getSubOptions []";
          nixosExpr = "${flake}.nixosConfigurations.${host.hostName}.options";
        in
        {
          language-server = {
            gopls.config = {
              gofumpt = true;
              "ui.diagnostic.staticcheck" = true;
            };

            nixd.config.nixd = {
              nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
              formatting.command = [ "nixfmt" ];

              options = {
                nixos.expr = nixosExpr;
                home-manager.expr = hmExpr;
                flake-parts.expr = "${flake}.debug.options";
                flake-parts-perSystem.expr = "${flake}.currentSystem.options";
              };
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
