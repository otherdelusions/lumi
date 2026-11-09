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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      };
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      forAllSystems =
        f: nixpkgs.lib.genAttrs [ "x86_64-linux" ] (system: f nixpkgs.legacyPackages.${system});

      treefmtEval = forAllSystems (pkgs: inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix);

      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self; };
          modules = [
            { networking.hostName = name; }
            ./hosts/common
            (./hosts + "/${name}")
          ];
        };
    in
    {
      nixosConfigurations = {
        ash = mkHost "ash";
        ember = mkHost "ember";
        interloper = mkHost "interloper";
      };

      homeManagerModules.dux-shell = ./modules/home/dux-shell.nix;

      nixosModules = nixpkgs.lib.genAttrs [
        "monbooru"
        "zapret"
        "librewolf"
      ] (name: ./modules/nixos + "/${name}.nix");

      packages = forAllSystems (pkgs: {
        monbooru = pkgs.callPackage ./packages/monbooru.nix { };
        morewaita-accent-icon-theme = pkgs.callPackage ./packages/morewaita-accent-icon-theme.nix { };
      });

      formatter = forAllSystems (
        pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper
      );

      checks = forAllSystems (pkgs: {
        formatting = treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.check self;
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          name = "lumi";

          NIX_CONFIG = "extra-experimental-features = nix-command flakes";
          DIRENV_WARN_TIMEOUT = "0s";

          packages = with pkgs; [
            nixd
            nixfmt
            statix
            yamlfmt
            just
            nurl
            inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
          ];
        };
      });
    };
}
