{ den, ... }:
{
  den.aspects.theming.includes = [ den.aspects.theming.helix ];

  den.aspects.theming.helix = {
    includes = [ den.aspects.theming.options ];

    provides.to-users.homeManager =
      { config, ... }:
      let
        inherit (config.theme) name;
      in
      {
        programs.helix = {
          settings.theme = name;

          themes.${name} = with config.theme.colors.withHashtag; {
            "attribute" = base0B;
            "comment" = {
              fg = base03;
              modifiers = [ "italic" ];
            };
            "constant" = base07;
            "constant.numeric" = base0B;
            "constructor" = base07;
            "debug" = base04;
            "diagnostic" = {
              modifiers = [ "underlined" ];
            };
            "diff.delta" = base0C;
            "diff.minus" = base09;
            "diff.plus" = base0F;
            "error" = base09;
            "function" = base07;
            "hint" = base04;
            "info" = base07;
            "keyword" = {
              fg = base07;
              modifiers = [ "bold" ];
            };
            "label" = base07;
            "namespace" = base07;
            "operator" = base07;
            "special" = base07;
            "string" = base0F;
            "tag" = base07;
            "type" = base0B;
            "variable" = base04;
            "variable.other.member" = base07;
            "warning" = base0C;

            "markup.bold" = {
              fg = base07;
              modifiers = [ "bold" ];
            };
            "markup.heading" = {
              fg = base07;
              modifiers = [ "bold" ];
            };
            "markup.italic" = {
              fg = base07;
              modifiers = [ "italic" ];
            };
            "markup.link.text" = base07;
            "markup.link.url" = {
              fg = base07;
              modifiers = [ "underlined" ];
            };
            "markup.list" = base04;
            "markup.quote" = base07;
            "markup.raw" = base07;
            "markup.strikethrough" = {
              modifiers = [ "crossed_out" ];
            };
            "diagnostic.hint" = {
              underline.style = "curl";
            };
            "diagnostic.info" = {
              underline.style = "curl";
            };
            "diagnostic.warning" = {
              underline.style = "curl";
            };
            "diagnostic.error" = {
              underline.style = "curl";
            };

            "ui.background" = {
              bg = base00;
            };
            "ui.bufferline.active" = {
              fg = base05;
              bg = base02;
              modifiers = [ "bold" ];
            };
            "ui.bufferline" = {
              fg = base04;
              bg = base00;
            };
            "ui.cursor" = {
              fg = base07;
              modifiers = [ "reversed" ];
            };
            "ui.cursor.primary" = {
              fg = base05;
              modifiers = [ "reversed" ];
            };
            "ui.cursorline.primary" = {
              bg = base01;
            };
            "ui.cursor.match" = {
              fg = base05;
              bg = base02;
              modifiers = [ "bold" ];
            };
            "ui.cursor.select" = {
              fg = base05;
              modifiers = [ "reversed" ];
            };
            "ui.gutter" = {
              bg = base00;
            };
            "ui.help" = {
              fg = base05;
              bg = base02;
            };
            "ui.linenr" = {
              fg = base04;
              bg = base00;
            };
            "ui.linenr.selected" = {
              fg = base04;
              bg = base01;
              modifiers = [ "bold" ];
            };
            "ui.menu" = {
              fg = base05;
              bg = base02;
            };
            "ui.menu.scroll" = {
              fg = base04;
              bg = base02;
            };
            "ui.menu.selected" = {
              fg = base05;
              bg = base01;
            };
            "ui.popup" = {
              bg = base02;
            };
            "ui.selection" = {
              fg = base05;
              bg = base02;
            };
            "ui.statusline" = {
              fg = base04;
              bg = base01;
            };
            "ui.statusline.insert" = {
              fg = base00;
              bg = base07;
            };
            "ui.statusline.normal" = {
              fg = base05;
              bg = base02;
            };
            "ui.statusline.select" = {
              fg = base05;
              bg = base06;
            };
            "ui.text" = base04;
            "ui.text.directory" = base07;
            "ui.text.focus" = base05;
            "ui.virtual.indent-guide" = {
              fg = base02;
            };
            "ui.virtual.inlay-hint" = {
              fg = base04;
            };
            "ui.virtual.ruler" = {
              bg = base01;
            };
            "ui.virtual.jump-label" = {
              fg = base07;
              modifiers = [ "bold" ];
            };
            "ui.virtual.whitespace" = {
              fg = base02;
            };
            "ui.window" = {
              fg = base03;
            };
          };
        };
      };
  };
}
