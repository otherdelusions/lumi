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

          character.format = "[ ](white)";

          fill.symbol = " ";

          directory = {
            format = "[  $path ](fg:black bg:green)";
            truncation_symbol = "…/";
          };

          git_branch.format = "[  $branch ](fg:black bg:blue)";

          nix_shell = {
            heuristic = true;
            format = "[  $name ](fg:black bg:cyan)";
          };

          git_status = {
            ignore_submodules = true;
            untracked = "?\$\{count\}";
            staged = "+\$\{count\}";
            modified = "!\$\{count\}";
            stashed = "\\$\$\{count\}";
            format = "[$staged$modified$untracked$stashed ](fg:black bg:blue)";
          };

          hostname = {
            ssh_only = true;
            format = "[ SSH ](fg:bright-white bold bg:red)";
          };
        };
      };
    };
  };
}
