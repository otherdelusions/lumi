{ den, ... }:
{
  den.aspects.browser.librewolf.includes = [ den.aspects.browser.librewolf.search ];

  den.aspects.browser.librewolf.search = {
    nixos = {
      programs.librewolf.policies.SearchEngines = {
        Remove = [
          "Google"
          "Bing"
          "Perplexity"
          "Wikipedia (en)"
        ];
        Add = [
          {
            Name = "DuckDuckGo-Dark";
            URLTemplate = "https://duckduckgo.com/?kae=d&q={searchTerms}";
            Method = "GET";
            IconURL = "https://duckduckgo.com/favicon.ico";
            SuggestURLTemplate = "https://duckduckgo.com/ac/?q={searchTerms}&type=list";
          }
          {
            Name = "NixOS Options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";
            Method = "GET";
            IconURL = "https://nixos.org/favicon.ico";
            Alias = "@no";
          }
          {
            Name = "NixOS Packages";
            URLTemplate = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
            Method = "GET";
            IconURL = "https://nixos.org/favicon.ico";
            Alias = "@np";
          }
          {
            Name = "NixOS HM Options";
            URLTemplate = "https://search.nixos.org/options?channel=unstable&query={searchTerms}&source=home_manager";
            Method = "GET";
            IconURL = "https://nixos.org/favicon.ico";
            Alias = "@hm";
          }
          {
            Name = "MyNixOS";
            URLTemplate = "https://mynixos.com/search?q={searchTerms}";
            Method = "GET";
            IconURL = "https://mynixos.com/favicon.ico";
            Alias = "@mn";
          }
          {
            Name = "Noogle";
            URLTemplate = "https://noogle.dev/q/?term={searchTerms}";
            Method = "GET";
            IconURL = "https://noogle.dev/favicon.ico";
            Alias = "@ng";
          }
        ];
        Default = "DuckDuckGo-Dark";
      };
    };
  };
}
