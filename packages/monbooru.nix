{
  perSystem =
    { pkgs, ... }:
    {
      packages.monbooru = pkgs.callPackage (
        {
          version ? "1.22.2",
          buildGo127Module,
          fetchFromGitHub,
          makeWrapper,
          ffmpeg,
          xdg-utils,
          lib,
          withTagger ? false,
          withDesktop ? false,
          onnxruntime,
        }:
        buildGo127Module {
          pname = "monbooru";
          inherit version;

          src = fetchFromGitHub {
            owner = "monbooru";
            repo = "monbooru";
            rev = "v${version}";
            hash = "sha256-H/ZAaN1b8w+rxqMCJ3Ree4DExk1/hQKJMt+joUbcDEQ=";
          };

          vendorHash = "sha256-8jDbVEdc6NvrqHkDzGv3knGMUKsDAKleb1qVABjH3tA=";
          subPackages = [ "cmd/monbooru" ];

          tags = lib.optional withTagger "tagger";
          env.CGO_ENABLED = if withTagger then 1 else 0;

          postPatch = lib.optionalString withDesktop ''
            # Autostart must use the wrapper, which supplies FFmpeg and ONNX Runtime.
            substituteInPlace internal/shared/desktop/integration.go \
              --replace-fail 'exe := Program()' 'exe := "${placeholder "out"}/bin/monbooru"'
            substituteInPlace internal/shared/desktop/integration_linux.go \
              --replace-fail '[]string{"/usr/", "/opt/"}' '[]string{"/usr/", "/opt/", "${builtins.storeDir}/"}'
          '';

          ldflags = [
            "-s"
            "-w"
            "-X github.com/monbooru/monbooru/internal/web.Version=${version}"
            "-X github.com/monbooru/monbooru/internal/web.RepoURL=https://github.com/monbooru/monbooru"
            "-X github.com/monbooru/monbooru/internal/web.DocURL=https://monbooru.github.io/mondocs/index.html"
            "-X github.com/monbooru/monbooru/internal/web.Package=nix"
          ]
          ++ lib.optional withDesktop "-X main.defaultDesktop=true";

          nativeBuildInputs = [ makeWrapper ];

          postInstall = ''
            wrapProgram $out/bin/monbooru \
              --prefix PATH : ${
                lib.makeBinPath ([ (ffmpeg.override { withJxl = true; }) ] ++ lib.optional withDesktop xdg-utils)
              } \
              ${lib.optionalString withTagger "--set-default ORT_LIB_PATH ${lib.getLib onnxruntime}/lib/libonnxruntime.so"}
          ''
          + lib.optionalString withDesktop ''
            install -Dm644 packaging/monbooru.desktop $out/share/applications/monbooru.desktop
            substituteInPlace $out/share/applications/monbooru.desktop \
              --replace-fail 'Exec=monbooru' "Exec=$out/bin/monbooru"
            for size in 48 64 128 256; do
              install -Dm644 packaging/icons/monbooru-$size.png \
                $out/share/icons/hicolor/''${size}x$size/apps/monbooru.png
            done
          '';

          doCheck = false;
          meta = {
            description = "Self-hosted, booru-style gallery";
            homepage = "https://github.com/monbooru/monbooru";
            changelog = "https://github.com/monbooru/monbooru/blob/v${version}/CHANGELOG.md";
            license = lib.licenses.agpl3Only;
            maintainers = [ ];
            mainProgram = "monbooru";
          };
        }
      ) { };
    };
}
