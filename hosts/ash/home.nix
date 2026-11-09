# hm users setup on host
{
  home-manager.users.ferret.imports = [
    ../../users/ferret/home/common
    ../../users/ferret/home/theme/helix.nix
    ../../users/ferret/home/theme/starship.nix
  ];
}
