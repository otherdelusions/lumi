{
  den.aspects.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.nurl ];
      };
  };
}
