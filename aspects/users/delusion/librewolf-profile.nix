{
  den.aspects.delusion = {
    homeManager =
      { inputs', ... }:
      {
        programs.librewolf.profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;

            extensions = {
              force = true;
              packages = with inputs'.firefox-addons.packages; [
                sponsorblock
              ];

              settings = {
                "uBlock0@raymondhill.net".settings = {
                  selectedFilterLists = [
                    "user-filters"
                    "ublock-filters"
                    "ublock-badware"
                    "ublock-privacy"
                    "ublock-quick-fixes"
                    "ublock-unbreak"
                    "easylist"
                    "easyprivacy"
                    "LegitimateURLShortener"
                    "adguard-spyware-url"
                    "urlhaus-1"
                    "curben-phishing"
                    "plowe-0"
                    "fanboy-cookiemonster"
                    "ublock-cookies-easylist"
                    "adguard-cookies"
                    "ublock-cookies-adguard"
                    "fanboy-ai-suggestions"
                    "easylist-chat"
                    "easylist-newsletters"
                    "easylist-notifications"
                    "easylist-annoyances"
                    "adguard-mobile-app-banners"
                    "adguard-other-annoyances"
                    "adguard-popup-overlays"
                    "adguard-widgets"
                    "ublock-annoyances"
                  ];
                };

                "sponsorBlocker@ajay.app".settings = {
                  trackDownvotesInPrivate = true;
                  hideVideoPlayerControls = true;
                  showUpsells = false;
                  showTimeWithSkips = false;
                  trackViewCount = false;
                  dontShowNotice = true;
                  hideInfoButtonPlayerControls = true;
                  showDonationLink = false;
                  showNewFeaturePopups = false;
                  showCategoryGuidelines = false;
                  allowScrollingToEdit = false;
                  cleanPopup = true;
                  categorySelections = [
                    {
                      name = "sponsor";
                      option = 2;
                    }
                    {
                      name = "poi_highlight";
                      option = 1;
                    }
                    {
                      name = "exclusive_access";
                      option = 0;
                    }
                    {
                      name = "chapter";
                      option = 0;
                    }
                    {
                      name = "selfpromo";
                      option = 2;
                    }
                    {
                      name = "outro";
                      option = 0;
                    }
                    {
                      name = "music_offtopic";
                      option = 1;
                    }
                  ];
                };
              };
            };
          };
        };
      };
  };
}
