{
  imports = [
    ./foot.nix
    ./user-dirs.nix
    ./librewolf
    ./niri
    ./dux-shell
    ./mpv.nix
  ];

  gtk.enable = true;
}
