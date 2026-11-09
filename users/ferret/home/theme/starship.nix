{ theme, ... }:
{
  imports = [ ./palette.nix ];

  programs.starship.settings = with theme.colors.withHashtag; {
    character.format = "[ ](fg:${base04})";
    directory.format = "[  $path ](fg:${base00} bg:${base07})";
    git_branch.format = "[  $branch ](fg:${base00} bg:${base08})";
    git_status.format = "[$staged$modified$untracked$stashed ](fg:${base00} bg:${base08})";
    nix_shell.format = "[  $name ](fg:${base04} bg:${base01})";
    hostname.format = "[ SSH ](bold fg:${base00} bg:${base0B})";
  };
}
