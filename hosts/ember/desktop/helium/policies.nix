{
  programs.helium.policies = {
    DnsOverHttpsMode = "secure";
    DnsOverHttpsTemplates = "https://dns.google/dns-query";
    MetricsReportingEnabled = false;
    SearchSuggestEnabled = true;
    DefaultBrowserSettingEnabled = true;
    PromptForDownloadLocation = true;
    ClearBrowsingDataOnExitList = [
      "browsing_history"
      "download_history"
      "autofill"
    ];
  };
}
