{
  flake.nixosModules.librewolf =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      cfg = config.programs.librewolf;
      policyFormat = pkgs.formats.json { };
    in
    {
      options.programs.librewolf = {
        enable = lib.mkEnableOption "Enable LibreWolf";

        policies = lib.mkOption {
          inherit (policyFormat) type;
          default = { };
        };
      };

      config = lib.mkIf cfg.enable {
        programs.firefox = {
          enable = true;
          package = pkgs.librewolf;
          inherit (cfg) policies;
        };

        environment.etc."firefox/policies/policies.json".target = "librewolf/policies/policies.json";
      };
    };
}
