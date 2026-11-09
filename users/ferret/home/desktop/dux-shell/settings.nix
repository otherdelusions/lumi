{
  programs.dux-shell.settings = {
    configVersion = 42;
    barElevationEnabled = false;
    radiusStrength = 0;
    runUserMatugenTemplates = false;
    runDmsMatugenTemplates = false;
    weatherEnabled = false;
    soundsEnabled = false;
    acMonitorTimeout = 600;
    acLockTimeout = 600;
    acSuspendTimeout = 1200;
    acProfileName = "2";
    batteryMonitorTimeout = 300;
    batteryLockTimeout = 300;
    batterySuspendTimeout = 600;
    batteryProfileName = "1";
    lockBeforeSuspend = true;
    clockFormat = "24h";
    notificationHistoryEnabled = false;
    notificationTimeoutLow = 3000;
    notificationTimeoutCritical = 30000;
    powerMenuGridLayout = true;
    dankLauncherV2Size = "medium";
    dankLauncherV2ShowFooter = false;
    audioVisualizerEnabled = false;
    dashCards = [
      {
        id = "clock";
        w = 2;
        h = 1;
        col = 0;
        row = 0;
      }
      {
        id = "weather";
        w = 1;
        h = 1;
      }
      {
        id = "notifications";
        w = 3;
        h = 3;
        col = 0;
        row = 1;
      }
      {
        id = "calendar";
        w = 3;
        h = 3;
        col = 3;
        row = 1;
      }
      {
        id = "media";
        w = 3;
        h = 1;
        col = 3;
        row = 0;
      }
    ];
    dashOptions.overview.panelRows = 4;
    controlCenterWidgets = [
      {
        id = "user";
        w = 5;
        col = 0;
        row = 0;
        badge = true;
        uptime = true;
        hostname = true;
        background = false;
      }
      {
        id = "settings";
        w = 1;
        col = 5;
        row = 0;
        small = true;
      }
      {
        id = "lock";
        w = 1;
        col = 6;
        row = 0;
        small = true;
      }
      {
        id = "power";
        w = 1;
        col = 7;
        row = 0;
        small = true;
      }
      {
        id = "volumeSlider";
        w = 4;
        col = 0;
        row = 1;
      }
      {
        id = "brightnessSlider";
        w = 4;
        col = 4;
        row = 1;
      }
      {
        id = "wifi";
        w = 4;
        col = 0;
        row = 2;
      }
      {
        id = "bluetooth";
        w = 4;
        col = 4;
        row = 2;
      }
      {
        id = "audioOutput";
        w = 4;
        col = 0;
        row = 3;
      }
      {
        id = "audioInput";
        w = 4;
        col = 4;
        row = 3;
      }
      {
        id = "doNotDisturb";
        w = 4;
        col = 0;
        row = 4;
      }
      {
        id = "idleInhibitor";
        w = 4;
        col = 4;
        row = 4;
      }
      {
        id = "edit";
        w = 1;
        col = 7;
        row = 5;
        small = true;
      }
      {
        id = "runningApps";
        w = 4;
        col = 0;
        row = 5;
        small = true;
      }
    ];
    builtInPluginSettings = {
      dms_clipboard_search.enabled = false;
      dms_notepad.enabled = false;
      dms_settings.enabled = false;
      dms_settings_search.enabled = false;
      dms_sysmon.enabled = false;
    };
    barConfigs = [
      {
        id = "default";
        name = "Main Bar";
        enabled = true;
        position = 3;
        screenPreferences = [ "all" ];
        leftWidgets = [
          {
            id = "workspaceSwitcher";
            showOccupiedWorkspacesOnly = true;
          }
        ];
        centerWidgets = [
          {
            id = "music";
            audioScrollMode = "nothing";
          }
          "clock"
          "keyboard_layout_name"
        ];
        rightWidgets = [
          "systemTray"
          "cpuUsage"
          "memUsage"
          "battery"
          {
            id = "controlCenterButton";
            showBluetoothIcon = false;
            showMicIcon = true;
          }
        ];
        spacing = 0;
        innerPadding = 4;
        scrollEnabled = false;
      }
    ];
  };
}
