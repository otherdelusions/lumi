{ den, ... }:
{
  den.aspects.tiling-wm.dms-shell.includes = [ den.aspects.tiling-wm.dms-shell.settings ];

  den.aspects.tiling-wm.dms-shell.settings = {
    homeManager = {
      programs.dank-material-shell.settings = {
        widgetBackgroundColor = "sth";
        cornerRadius = 0;
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
        showDock = false;
        notificationOverlayEnabled = false;
        notificationTimeoutLow = 5000;
        notificationTimeoutNormal = 5000;
        notificationTimeoutCritical = 0;
        powerMenuGridLayout = true;
        controlCenterShowBluetoothIcon = false;
        controlCenterShowAudioPercent = false;
        controlCenterShowBrightnessIcon = false;
        controlCenterShowMicIcon = true;
        controlCenterShowMicPercent = false;
        controlCenterShowBatteryIcon = false;
        controlCenterShowPrinterIcon = false;

        lockScreenShowProfileImage = false;
        dankLauncherV2Size = "medium";
        dankLauncherV2ShowFooter = false;

        controlCenterWidgets = [
          {
            id = "volumeSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "brightnessSlider";
            enabled = true;
            width = 50;
          }
          {
            id = "wifi";
            enabled = true;
            width = 50;
          }
          {
            id = "bluetooth";
            enabled = true;
            width = 50;
          }
          {
            id = "audioOutput";
            enabled = true;
            width = 50;
          }
          {
            id = "audioInput";
            enabled = true;
            width = 50;
          }
          {
            id = "doNotDisturb";
            enabled = true;
            width = 50;
          }
          {
            id = "idleInhibitor";
            enabled = true;
            width = 50;
          }
        ];

        builtInPluginSettings = {
          dms_settings_search.enabled = false;
          dms_sysmon.enabled = false;
          dms_notepad.enabled = false;
          dms_settings.enabled = false;
        };

        barConfigs = [
          {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 2;
            screenPreferences = [ "all" ];
            showOnLastDisplay = true;
            leftWidgets = [ "workspaceSwitcher" ];
            centerWidgets = [
              "music"
              "clock"
            ];
            rightWidgets = [
              "systemTray"
              "cpuUsage"
              "memUsage"
              "battery"
              "controlCenterButton"
            ];
            spacing = 0;
            innerPadding = 4;
            bottomGap = 0;
            transparency = 1;
            widgetTransparency = 1;
            squareCorners = false;
            noBackground = false;
            gothCornersEnabled = false;
            borderEnabled = false;
            borderOpacity = 1;
            borderThickness = 1;
            fontScale = 1;
            autoHide = false;
            openOnOverview = false;
            visible = true;
            popupGapsAuto = true;
            widgetPadding = 8;
            scrollEnabled = false;
            shadowIntensity = 0;
          }
        ];
      };
    };
  };
}
