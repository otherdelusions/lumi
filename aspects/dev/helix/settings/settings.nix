{ den, ... }:
{
  den.aspects.dev.helix.includes = [ den.aspects.dev.helix.settings ];

  den.aspects.dev.helix.settings = {
    homeManager = {
      programs.helix.settings = {
        editor = {
          scrolloff = 18;
          line-number = "relative";
          mouse = false;
          bufferline = "multiple";
          color-modes = true;
          "cursor-shape" = {
            normal = "block";
            insert = "bar";
            select = "block";
          };
          completion-replace = true;
          "indent-guides" = {
            render = false;
            character = "▏";
          };
          statusline.right = [
            "diagnostics"
            "version-control"
            "position"
            "file-line-ending"
            "file-encoding"
          ];
        };

        keys.normal = {
          ret = "goto_word";
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
        };
      };
    };
  };
}
