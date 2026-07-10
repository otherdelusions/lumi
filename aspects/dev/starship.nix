{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.starship ];

  den.aspects.dev.starship = {
    homeManager =
      { config, ... }:
      {
        programs.starship =
          let
            mkBracketsSame = text: col: "[\\[](${col})[${text}](${col})[\\]](${col})";
          in
          {
            enable = true;
            enableFishIntegration = config.programs.fish.enable;
            enableInteractive = true;

            settings = {
              command_timeout = 5000;
              format = ''
                $directory$git_branch$git_status$fill$nix_shell
                $character'';

              character.format = "[ ](base04)";

              fill.symbol = " ";

              directory = {
                format = "[  $path ](fg:base00 bg:base14)";
                truncation_symbol = "…/";
              };

              git_branch.format = "[  $branch ](fg:base00 bg:base16)";

              nix_shell = {
                heuristic = true;
                format = "[  $name ](fg:base01 bg:base15)";
              };

              git_status = {
                ignore_submodules = true;
                untracked = "?\$\{count\}";
                staged = "+\$\{count\}";
                modified = "!\$\{count\}";
                stashed = "\\$\$\{count\}";
                format = "[$staged$modified$untracked$stashed ](fg:base00 bg:base16)";
              };

              hostname = {
                ssh_only = false;
                ssh_symbol = "${mkBracketsSame "SSH" "base06"}";
                format = "[@](base17)$ssh_symbol[$hostname](base17)";
              };

              username = {
                show_always = true;
                style_user = "base17";
                style_root = "base09";
                format = "[$user]($style)";
              };
            };
          };
      };
  };
}
