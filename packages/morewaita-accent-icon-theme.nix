{
  stdenv,
  lib,
  fetchFromGitHub,
  gtk3,
  adwaita-icon-theme,
  morewaita-icon-theme,
  accentColor ? "",
}:
let
  morewaita = morewaita-icon-theme.overrideAttrs (
    finalAttrs: _: {
      version = "50.1";
      src = fetchFromGitHub {
        owner = "somepaulo";
        repo = "MoreWaita";
        tag = "v${finalAttrs.version}";
        hash = "sha256-TKy7NJt+r4MX2qq0F4aqpfh3levf7r6q9+2/2ZsWSBk=";
      };
    }
  );

  variant = if accentColor == "" then "blue" else "accent";
  accent = lib.removePrefix "#" accentColor;

  brighten = channel: lib.min 255 (lib.fromHexString channel * 135 / 100);
  hexByte = n: lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString n));
  highlight = lib.concatMapStrings (offset: hexByte (brighten (builtins.substring offset 2 accent))) [
    0
    2
    4
  ];
in
stdenv.mkDerivation {
  pname = "morewaita-accent-icon-theme";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "dpejoh";
    repo = "Adwaita-colors";
    rev = "7d838af258da4ca05040760301d05140aa858145";
    hash = "sha256-EncnmE5Ck7QnebyU5zW4L5yV9wIW2yLr4lB1FgqG+0A=";
  };

  nativeBuildInputs = [
    gtk3
  ];
  propagatedBuildInputs = [
    morewaita
    adwaita-icon-theme
  ];

  dontDropIconThemeCache = true;
  dontBuild = true;

  postPatch = ''
    sed -i 's|ADWAITA_PATHS=(|ADWAITA_PATHS=(\n    "${adwaita-icon-theme}/share/icons/Adwaita"|' variants.conf
    sed -i 's|recolor_svgs "\$variant" "\$theme_dir"|chmod -R u+w "$theme_dir"\n    &|' setup
    patchShebangs setup
  ''
  + lib.optionalString (variant == "accent") ''
    # register accent as an extra color variant
    echo 'COLOR_MAP[accent]="3f8ae5:${accent} 438de6:${accent} 62a0ea:${accent} a4caee:${highlight} afd4ff:${highlight} c0d5ea:${highlight}"' >> variants.conf
    sed -i 's/^ALL_VARIANTS=(\(.*\))/ALL_VARIANTS=(\1 accent)/' variants.conf
    cp -r mimetypes/blue mimetypes/accent
  '';

  installPhase = ''
    runHook preInstall

    export HOME=$TMPDIR/home
    mkdir -p "$HOME/.local/share/icons"
    ./setup -i -p "$HOME/.local/share/icons" -f ${variant}

    find "$HOME/.local/share/icons" -xtype l -delete

    theme="$HOME/.local/share/icons/Adwaita-${variant}"
    sed -i 's/^Inherits=.*/Inherits=MoreWaita,Adwaita,AdwaitaLegacy,hicolor/' "$theme/index.theme"
    gtk-update-icon-cache -f "$theme"

    mkdir -p $out/share/icons
    cp -r "$HOME/.local/share/icons/Adwaita-"* $out/share/icons/

    runHook postInstall
  '';
}
