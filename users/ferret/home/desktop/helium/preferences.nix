{
  programs.helium.preferences = {
    browser.custom_chrome_frame = false;
    ntp.shortcust_visible = false;

    helium.services = {
      enabled = true;
      user_consented = true;
      ext_proxy = true;
    };

    profile = {
      name = "ferret";
      using_default_name = false;
      default_content_setting_values.cookies = 4;
    };
  };
}
