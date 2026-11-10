{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      hwdec = "auto-safe";
      profile = "high-quality";
      osc = false;
      osd-bar = false;
      title-bar = false;
      keep-open = true;
      deband = true;
      screenshot-directory = "~/Pictures/Screenshots";
      screenshot-format = "png";
      screenshot-png-compression = 0;
      screenshot-template = "%F_%wH.%wM.%wS_%n";
    };

    scripts = with pkgs.mpvScripts; [
      modernz
      thumbfast
    ];

    scriptOpts = {
      modernz = {
        keeponpause = "both";
        window_controls = false;
        fullscreen_button = false;
        ontop_button = false;
      };
    };
  };
}
