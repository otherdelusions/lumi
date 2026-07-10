{ den, ... }:
{
  den.aspects.browser.librewolf.includes = [ den.aspects.browser.librewolf.preferences ];

  den.aspects.browser.librewolf.preferences = {
    nixos = {
      programs.librewolf.policies = {
        DisableAppUpdate = true;
        SearchSuggestEnabled = true;
        DisableSetDesktopBackground = true;
        OfferToSaveLogins = false;
        TranslateEnabled = false;
        DisableTelemetry = true;
        VisualSearchEnabled = false;
        NoDefaultBookmarks = true;

        PictureInPicture.Enabled = false;

        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };

        GenerativeAI = {
          Enabled = false;
          Locked = true;
        };

        SanitizeOnShutdown = {
          Cache = true;
          Cookies = true;
          Downloads = true;
          FormData = true;
          History = true;
          Sessions = true;
        };

        DNSOverHTTPS = {
          Enabled = true;
          ProviderURL = "https://cloudflare-dns.com/dns-query";
          Fallback = true;
        };

        UserMessaging = {
          ExtensionRecommendations = false;
          FeatureRecommendations = false;
          UrlbarInterventions = false;
          SkipOnboarding = true;
          MoreFromMozilla = false;
          FirefoxLabs = false;
        };

        Preferences = {
          "browser.search.suggest.enabled.private" = true;
          "browser.search.suggest.enabledOverride" = true;
          "browser.urlbar.suggest.addons" = false;
          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.importantDates" = false;
          "browser.urlbar.suggest.mdn" = false;
          "browser.urlbar.suggest.sports" = false;
          "browser.urlbar.suggest.topsites" = false;
          "browser.urlbar.suggest.trending" = false;
          "browser.urlbar.suggest.wikipedia" = false;
          "browser.urlbar.suggest.yelp" = false;
          "browser.urlbar.suggest.yelpRealtime" = false;
          "browser.urlbar.trimURLs" = false;
          "browser.search.separatePrivateDefault" = false;
          "browser.toolbars.bookmarks.visibility" = "newtab";
          "network.cookie.cookieBehavior" = 1;
          "browser.sessionstore.resume_from_crash" = false;
          "network.lna.blocking" = true;
          "network.lna.block_trackers" = true;
          "browser.warnOnQuitShortcut" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "general.smoothScroll.msdPhysics.enabled" = true;
          "geo.enabled" = false;
        };
      };
    };
  };
}
