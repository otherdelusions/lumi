{
  description = "NixOS configurations";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://nix-community.cachix.org"
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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix/3861e2249cb244bfbc7cfab2303c152cf5f9d9e9";

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule

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
          desktop.compositor = "niri";
          desktop.terminal = "foot";

          users.ferret = { };
        };

        interloper = { };
      };

      perSystem =
        {
          pkgs,
          config,
          inputs',
          ...
        }:
        {
          treefmt.config = {
            flakeCheck = false;

            programs = {
              nixfmt.enable = true;
              yamlfmt.enable = true;
            };
          };

          pre-commit.settings.hooks = {
            actionlint.enable = true;

            treefmt = {
              enable = true;
              package = config.treefmt.build.wrapper;
            };

            markdownlint = {
              enable = true;
              settings.configuration = {
                MD013 = false;
                MD033 = false;
              };
            };

            convco.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "lumi";
            inherit (config.pre-commit) shellHook;
            NIX_CONFIG = "extra-experimental-features = nix-command flakes";
            DIRENV_WARN_TIMEOUT = "0s";

            packages = [
              pkgs.just
              pkgs.nurl
              pkgs.caligula
              inputs'.disko.packages.disko
            ];
          };
        };
    };
}
