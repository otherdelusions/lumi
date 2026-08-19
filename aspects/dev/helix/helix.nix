{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.helix ];

  den.aspects.dev.helix = {
    homeManager =
      {
        host,
        lib,
        pkgs,
        ...
      }:
      let
        terminal = host.desktop.terminal;
      in
      {
        programs.helix = {
          enable = true;
          package = pkgs.steelix;
          defaultEditor = true;

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
      };
  };
}
