{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.core.localization or { };
in
{
  config = {
    custom.users.csl = {
      core.localization = lib.mkIf (customCfg.enable or false) {
        mainLocale = "zh_CN.UTF-8";
        mainLocaleSupport = "zh_CN.UTF-8/UTF-8";
        ttyForceDefaultLocale = true;
      };
    };
  };
}
