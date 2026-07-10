{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.git ];

  den.aspects.dev.git = {
    homeManager = {
      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          color.ui = "auto";
          diff.algorithm = "histogram";

          pull.rebase = true;

          push = {
            default = "simple";
            autoSetupRemote = true;
          };

          rerere = {
            enabled = true;
            autoupdate = true;
          };

          merge = {
            conflictstyle = "diff3";
            stat = "true";
          };

          rebase = {
            autosquash = true;
            autostash = true;
          };

          alias = {
            l = "log --oneline --graph";
            cm = "commit -m";
            lock = "!git add flake.lock && git chore flake \"update flake.lock\"";
            chore = "!f() { git commit -m \"chore\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            docs = "!f() { git commit -m \"docs\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            feat = "!f() { git commit -m \"feat\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            fix = "!f() { git commit -m \"fix\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            refactor = "!f() { git commit -m \"refactor\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            style = "!f() { git commit -m \"style\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
            fmt = "!f() { git commit -m \"style\${1:+($1)}: formatting\" \${2:+-m \"$2\"}; }; f";
            test = "!f() { git commit -m \"test\${1:+($1)}: $2\" \${3:+-m \"$3\"}; }; f";
          };
        };

        ignores = [
          ".direnv"
        ];
      };
    };
  };
}
