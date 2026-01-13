{
  config,
  lib,
  pkgs,
  ...
}:
{
  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";

  i18n.inputMethod.fcitx5 = {
    waylandFrontend = true;

    addons = with pkgs; [
      fcitx5-gtk

      fcitx5-pinyin-zhwiki
      fcitx5-pinyin-moegirl
      fcitx5-pinyin-minecraft
      kdePackages.fcitx5-chinese-addons

      fcitx5-fluent
    ];

    settings.inputMethod = {
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "pinyin";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "pinyin";

      "GroupOrder"."0" = "Default";
    };

    settings.globalOptions = {
      "Hotkey" = {
        EnumerateWithTriggerKeys = "True";
        TriggerKeys = "";
        ActivateKeys = "";
        DeactivateKeys = "";
        AltTriggerKeys = "";
        EnumerateBackwardKeys = "";
        EnumerateGroupBackwardKeys = "";
        EnumerateSkipFirst = "False";
      };
      "Hotkey/EnumerateForwardKeys"."0" = "Control+space";
      "Hotkey/EnumerateGroupForwardKeys"."0" = "Control+Shift+space";
      "Hotkey/PrevPage" = {
        "0" = "Up";
        "1" = "bracketleft";
      };
      "Hotkey/NextPage" = {
        "0" = "Down";
        "1" = "bracketright";
      };
      "Hotkey/PrevCandidate" = {
        "0" = "Left";
        "1" = "Shift+Tab";
      };
      "Hotkey/NextCandidate" = {
        "0" = "Right";
        "1" = "Tab";
      };

      "Behavior" = {
        ActiveByDefault = "False";
        PreeditEnabledByDefault = "False";
        ShowInputMethodInformation = "True";
        CompactInputMethodInformation = "False";
        ShowFirstInputMethodInformation = "True";
        DefaultPageSize = 7;
      };
    };

    settings.addons.classicui = {
      globalSection.Theme = "FluentDark-solid";
      globalSection.DarkTheme = "FluentDark-solid";
    };
  };

  # Fcitx5 should not be automatically started before the Wayland compositor,
  # otherwise it will occupy the DBus name and prevent other applications from
  # successful initialization.
  systemd.user.units."app-org.fcitx.Fcitx5@autostart.service".enable = false;
}
