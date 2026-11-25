{
  programs.helium.commandLineArgs = [
    "--disable-features=OverscrollHistoryNavigation"

    # hardening flags taken from
    # https://github.com/ungoogled-software/ungoogled-chromium/blob/master/docs/flags.md
    "--enable-features=WaylandWindowDecorations,WaylandUnscaledTouchpadScrolling:scroll_scaling_factor/5,SpoofWebGLInfo,RemoveClientHints"
    "--disable-search-engine-collection"
    "--force-punycode-hostnames"
    "--disable-beforeunload"
  ];
}
