{
  programs.dux-shell.enable = true;

  services.displayManager.dux-greeter = {
    enable = true;
    compositor.name = "niri";
    logs.save = true;
  };
}
