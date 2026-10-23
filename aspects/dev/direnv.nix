{ den, ... }:
{
  den.aspects.dev.includes = [ den.aspects.dev.direnv ];

  den.aspects.dev.direnv = {
    homeManager =
      { lib, ... }:
      {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;

          config.global.log_filter = lib.mkDefault "loading|using|nix-direnv|execute";
        };
      };
  };
}
