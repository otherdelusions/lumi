{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.starship ];

  den.aspects.dev.starship = {
    homeManager = {
      programs.starship = {
        enable = true;

        settings = {
          command_timeout = 5000;
          format = ''
            $hostname$directory$git_branch$git_status$fill$nix_shell
            $character'';

          fill.symbol = " ";

          directory = {
            truncation_symbol = "…/";
          };

          nix_shell = {
            heuristic = true;
          };

          git_status = {
            ignore_submodules = true;
            untracked = "?\$\{count\}";
            staged = "+\$\{count\}";
            modified = "!\$\{count\}";
            stashed = "\\$\$\{count\}";
          };

          hostname = {
            ssh_only = true;
          };
        };
      };
    };
  };
}
