{
  description = "NixOS configurations";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com?priority=50"
      "https://nix-community.cachix.org?priority=50"
      "https://lumi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lumi.cachix.org-1:PISr+52IJ/d1NpLfo7mYIR+FA96rocIWohlMjKJbQY0="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    den.url = "github:denful/den";

    import-tree.url = "github:vic/import-tree";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-secrets = {
      url = "github:unnamed-systems/nix-secrets";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix/3861e2249cb244bfbc7cfab2303c152cf5f9d9e9";

    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    copyparty = {
      url = "github:9001/copyparty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.den.flakeModule

        (inputs.import-tree [
          ./aspects
          ./modules
          ./packages
        ])
      ];

      debug = true; # for nixd flake-parts expr

      den.hosts.x86_64-linux = {
        ash = {
          users.ferret = { };
        };

        ember = {
          desktop.terminal = "foot";

          users.ferret = { };
        };

        interloper = { };
      };

      perSystem =
        {
          pkgs,
          inputs',
          ...
        }:
        {
          formatter = pkgs.nixfmt-tree.override {
            runtimeInputs = [ pkgs.yamlfmt ];
            settings.formatter.yamlfmt = {
              command = "yamlfmt";
              includes = [
                "*.yaml"
                "*.yml"
              ];
            };
          };

          checks.lint =
            pkgs.runCommand "check-lint"
              {
                nativeBuildInputs = with pkgs; [
                  nixfmt
                  deadnix
                  statix
                  yamlfmt
                  actionlint
                  markdownlint-cli
                ];
              }
              ''
                cd ${inputs.self}

                echo "Running nixfmt..."
                find . -type f -name '*.nix' -exec nixfmt --check {} +

                echo "Running deadnix..."
                deadnix --fail

                echo "Running statix..."
                statix check .

                echo "Running yamlfmt & actionlint..."
                find . -type f \( -name '*.yaml' -o -name '*.yml' \) -exec yamlfmt -lint {} +
                find .github/workflows -type f \( -name '*.yaml' -o -name '*.yml' \) -exec actionlint {} +

                echo "Running markdownlint..."
                markdownlint --dot --disable MD013 MD033 -- .

                touch "$out" # success
              '';

          devShells.default = pkgs.mkShell {
            name = "lumi";

            NIX_CONFIG = "extra-experimental-features = nix-command flakes";
            DIRENV_WARN_TIMEOUT = "0s";

            packages = with pkgs; [
              nixd
              nixfmt
              yamlfmt
              just
              nurl
              inputs'.disko.packages.disko
            ];
          };
        };
    };
}
