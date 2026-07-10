{ den, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.locale ];

  den.aspects.common.locale = {
    nixos =
      { lib, ... }:
      {
        time.timeZone = lib.mkDefault "UTC";

        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = lib.genAttrs [
            "LC_NUMERIC"
            "LC_MONETARY"
            "LC_PAPER"
            "LC_MEASUREMENT"
            "LC_TELEPHONE"
          ] (_: "ru_RU.UTF-8");
        };
      };
  };
}
