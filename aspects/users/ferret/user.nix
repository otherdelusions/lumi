{ den, ... }:
{
  den.aspects.ferret = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")
      den.batteries.host-aspects
    ];

    homeManager = {
      programs.home-manager.enable = true;
    };
  };
}
