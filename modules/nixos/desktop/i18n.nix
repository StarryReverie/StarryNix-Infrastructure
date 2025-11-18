{ config, lib, pkgs, ... }:

let
  flags = config.flags.packages.desktop.i18n;
in {
  config = lib.mkIf flags.enable {
    i18n.defaultLocale = "zh_CN.UTF-8";
    i18n.inputMethod.enable = true;
    i18n.inputMethod.type = "fcitx5";
    i18n.inputMethod.fcitx5 = {
      addons = with pkgs; [ qt6Packages.fcitx5-chinese-addons ];
    };
  };
}
