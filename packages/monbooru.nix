{
  perSystem =
    { pkgs, ... }:
    {
      packages.monbooru = pkgs.callPackage (
        {
          version ? "1.19.1",
          buildGoModule,
          fetchFromGitHub,
          makeWrapper,
          ffmpeg,
          lib,
          withTagger ? false,
          onnxruntime ? null,
        }:
        buildGoModule {
          pname = "monbooru";
          inherit version;

          src = fetchFromGitHub {
            owner = "monbooru";
            repo = "monbooru";
            rev = "v${version}";
            hash = "sha256-Onhi5g3vva3tQIwHe2CaQw7vTQyDO1SMQMRvG03SiEQ=";
          };

          vendorHash = "sha256-tl8KidBWyX382Kd0YYJ1+AniTgGuTCISewdbq4IFNvE=";
          subPackages = [ "cmd/monbooru" ];

          tags = lib.optional withTagger "tagger";
          env.CGO_ENABLED = if withTagger then 1 else 0;

          ldflags = [
            "-s"
            "-w"
            "-X github.com/monbooru/monbooru/internal/web.Version=${version}"
            "-X github.com/monbooru/monbooru/internal/web.RepoURL=https://github.com/monbooru/monbooru"
            "-X github.com/monbooru/monbooru/internal/web.RepoURL=https://monbooru.github.io/mondocs/index.html"
          ];

          nativeBuildInputs = [ makeWrapper ];

          postInstall = ''
            wrapProgram $out/bin/monbooru \
            --prefix PATH : ${lib.makeBinPath [ ffmpeg ]} \
            ${lib.optionalString withTagger "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ onnxruntime ]}"}
          '';

          doCheck = false;
          meta = {
            description = "Self-hosted, booru-style gallery";
            homepage = "https://github.com/monbooru/monbooru";
            changelog = "https://github.com/monbooru/monbooru/blob/v${version}/CHANGELOG.md";
            licence = lib.licenses.agpl3Only;
            maintainers = [ ];
            mainProgram = "monbooru";
          };
        }
      ) { };
    };
}
