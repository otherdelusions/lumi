{
  den.aspects.dev.ai = {
    homeManager =
      {
        inputs',
        lib,
        config,
        pkgs,
        ...
      }:
      let
        karpathy-skills = pkgs.fetchFromGitHub {
          owner = "forrestchang";
          repo = "andrej-karpathy-skills";
          rev = "2c606141936f1eeef17fa3043a72095b4765b9c2";
          hash = "sha256-4z/wRdYH7UXRzF8RJU0sw8xbpx0BW/7CBv5sVEC2knY=";
        };
      in
      {
        programs.claude-code = {
          enable = true;
          package = inputs'.llm-agents.packages.claude-code;

          settings = {
            attribution = {
              commit = "";
              pr = "";
            };
            alwaysThinkingEnabled = true;
            awaySummaryEnabled = false;
            theme = "dark-ansi";
            effortLevel = "xhigh";

            enabledPlugins = {
              "andrej-karpathy-skills@karpathy-skills" = true;
            };

            env = {
              CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY = "1";
              DISABLE_TELEMETRY = "1";
              DISABLE_ERROR_REPORTING = "1";
              DISABLE_NON_ESSENTIAL_MODEL_CALLS = "1";
            };

            permissions = {
              allow = [
                "Bash(git diff:*)"
                "Bash(git status:*)"
                "Bash(git log:*)"
                "Bash(git show:*)"
                "Bash(git blame:*)"
                "Bash(nix eval:*)"
                "Bash(nix flake check:*)"
                "Bash(nix flake show:*)"
                "Bash(nix repl:*)"
              ];
              ask = [
                "Bash(git push:*)"
                "Bash(git add:*)"
                "Bash(nixos-rebuild switch:*)"
                "Bash(nixos-rebuild boot:*)"
              ];
              deny = [
                "Read(./secrets/**)"
                "Read(~/.config/sops/**)"
                "Read(~/.ssh/id_*)"
              ];
            };
          };

          mcpServers = {
            nixos = {
              type = "stdio";
              command = lib.getExe' pkgs.coreutils "env";
              args = [
                "-u"
                "all_proxy"
                (lib.getExe pkgs.mcp-nixos)
              ];
            };

            context7 = {
              type = "stdio";
              command = lib.getExe pkgs.context7-mcp;
            };
          };

          marketplaces = {
            inherit karpathy-skills;
          };
        };

        programs.git.ignores = lib.optional config.programs.claude-code.enable ".claude";
      };
  };
}
