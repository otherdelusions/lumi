{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.helix ];

  den.aspects.dev.helix = {
    homeManager =
      {
        host,
        inputs',
        lib,
        config,
        pkgs,
        ...
      }:
      let
        terminal = host.desktop.terminal;
      in
      {
        programs.helix = {
          enable = true;
          package = inputs'.helix.packages.helix;

          extraPackages = with pkgs; [
            nixd
            nixfmt
            yamlfmt
            gopls
            golangci-lint
            golangci-lint-langserver
          ];
        };

        xdg.desktopEntries."helix-terminal" = lib.mkIf (terminal != null) {
          name = "Helix (${terminal} window)";
          icon = "helix";
          exec = "${terminal} -e hx %F";
          type = "Application";
          noDisplay = true;
          terminal = false;
        };

        home.sessionVariables = lib.mkIf config.programs.helix.enable {
          EDITOR = lib.mkDefault "hx";
          VISUAL = lib.mkDefault "hx";
        };
      };
  };
}
