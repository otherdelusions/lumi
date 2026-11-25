{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    ;

  inherit (lib.types) attrsOf;

  cfg = config.programs.helium;
  policyFormat = pkgs.formats.json { };
in
{
  options.programs.helium = {
    enable = mkEnableOption "Helium policies";

    policies = mkOption {
      type = attrsOf policyFormat.type;
      default = { };
      example = {
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderSearchURL = "https://duckduckgo.com/?q={searchTerms}";
      };
      description = ''
        Enforced Chromium policies shared by all users
        Refer to https://chromeenterprise.google/policies/ for supported values
      '';
    };

    recommendedPolicies = mkOption {
      type = attrsOf policyFormat.type;
      default = { };
      example = {
        SearchSuggestEnabled = true;
      };
      description = "Subset of Chromium policies that users can override in browser settings";
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "chromium/policies/managed/helium.json" = mkIf (cfg.policies != { }) {
        source = policyFormat.generate "helium-policies.json" cfg.policies;
      };

      "chromium/policies/recommended/helium.json" = mkIf (cfg.recommendedPolicies != { }) {
        source = policyFormat.generate "helium-recommended-policies.json" cfg.recommendedPolicies;
      };
    };
  };
}
