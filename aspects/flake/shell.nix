{
  perSystem =
    {
      pkgs,
      config,
      inputs',
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        name = "nixc";
        inherit (config.pre-commit) shellHook;
        NIX_CONFIG = "extra-experimental-features = nix-command flakes";
        DIRENV_WARN_TIMEOUT = "0s";

        packages =
          with pkgs;
          [
            just
            nurl
            caligula
          ]
          ++ [
            inputs'.disko.packages.disko
          ];
      };
    };
}
