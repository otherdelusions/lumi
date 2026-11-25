{
  programs.helium.policies = {
    DefaultSearchProviderEnabled = true;
    DefaultSearchProviderName = "DuckDuckGo-Dark";
    DefaultSearchProviderSearchURL = "https://duckduckgo.com/?kae=d&q={searchTerms}";
    DefaultSearchProviderSuggestURL = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
    DefaultSearchProviderIconURL = "https://duckduckgo.com/favicon.ico";

    SiteSearchSettings = [
      {
        name = "NixOS Options";
        shortcut = "!no";
        url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
      }
      {
        name = "NixOS Packages";
        shortcut = "!np";
        url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
      }
      {
        name = "NixOS HM Options";
        shortcut = "!hm";
        url = "https://search.nixos.org/options?channel=unstable&query={searchTerms}&source=home_manager";
      }
      {
        name = "MyNixOS";
        shortcut = "!mn";
        url = "https://mynixos.com/search?q={searchTerms}";
      }
      {
        name = "Noogle";
        shortcut = "!ng";
        url = "https://noogle.dev/q/?term={searchTerms}";
      }
    ];
  };
}
