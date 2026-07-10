{
  perSystem =
    { pkgs, ... }:
    {
      packages.morewaita-stylix-icon-theme = pkgs.callPackage (
        {
          lib,
          pkgs,
          accentColor ? "",
        }:
        let
          variant = if accentColor == "" then "blue" else "stylix";
          accent = lib.removePrefix "#" accentColor;
          brighten = channel: lib.min 255 (lib.fromHexString channel * 135 / 100);
          hexByte = n: lib.toLower (lib.fixedWidthString 2 "0" (lib.toHexString n));
          highlight = lib.concatMapStrings (offset: hexByte (brighten (builtins.substring offset 2 accent))) [
            0
            2
            4
          ];
        in
        pkgs.stdenv.mkDerivation {
          pname = "morewaita-stylix-icon-theme";
          version = "367849d";

          src = pkgs.fetchFromGitHub {
            owner = "dpejoh";
            repo = "Adwaita-colors";
            rev = "367849dcdd269f9be17b143763eb7279087ab88c";
            hash = "sha256-R71ZRoDdlWJy+TkWkmXwyRWJTAYi4QOSmnO6GiOfGCM=";
          };

          nativeBuildInputs = with pkgs; [
            gtk3
            adwaita-icon-theme
          ];
          propagatedBuildInputs = with pkgs; [
            morewaita-icon-theme
            adwaita-icon-theme
          ];
          dontDropIconThemeCache = true;
          dontBuild = true;

          postPatch = ''
            sed -i 's|ADWAITA_PATHS=(|ADWAITA_PATHS=(\n    "${pkgs.adwaita-icon-theme}/share/icons/Adwaita"|' variants.conf
            sed -i 's|recolor_svgs "\$variant" "\$theme_dir"|chmod -R u+w "$theme_dir"\n    &|' setup
            patchShebangs setup
          ''
          + lib.optionalString (variant == "stylix") ''
            # register accent as an extra color variant
            echo 'COLOR_MAP[stylix]="3f8ae5:${accent} 438de6:${accent} 62a0ea:${accent} a4caee:${highlight} afd4ff:${highlight} c0d5ea:${highlight}"' >> variants.conf
            sed -i 's/^ALL_VARIANTS=(\(.*\))/ALL_VARIANTS=(\1 stylix)/' variants.conf
            cp -r mimetypes/blue mimetypes/stylix
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
      ) { };
    };
}
