{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.fish ];

  den.aspects.dev.fish = {
    nixos = {
      programs.fish.enable = true;
    };

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        programs.fish = {
          enable = true;
          shellAliases = {
            ls = "ls -A --color=auto --group-directories-first";
          };

          interactiveShellInit = ''
            set -g fish_greeting
          '';

          functions = {
            proxy-on = ''
              set -gx http_proxy "http://127.0.0.1:7890"
              set -gx https_proxy "http://127.0.0.1:7890"
              set -gx all_proxy "socks5://127.0.0.1:7890"
              echo "proxy on"
            '';
            proxy-off = ''
              set -ge http_proxy
              set -ge https_proxy
              set -ge all_proxy
              echo "proxy off"
            '';
          };
        };

        home.packages = lib.optional config.programs.fish.enable pkgs.fish-lsp;
      };
  };
}
