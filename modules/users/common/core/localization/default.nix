{
  config,
  lib,
  pkgs,
  ...
}:
let
  customLocalizationSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.core.localization;
    in
    {
      options.core.localization = {
        mainLocale = lib.mkOption {
          type = lib.types.str;
          description = "Main locale to be assigned to `$LANG` in most environment, except TTY";
          example = "zh_CN.UTF-8";
        };

        mainLocaleSupport = lib.mkOption {
          type = lib.types.str;
          description = "Main locale that the system should support.";
          example = "zh_CN.UTF-8/UTF-8";
        };

        ttyForceDefaultLocale = lib.mkOption {
          type = lib.types.bool;
          description = "Set locale to default in tty to prevent displaying tofu";
          default = false;
          example = true;
        };
      };

      config = lib.mkMerge [
        (lib.mkIf (customCfg.enable && !customCfg.ttyForceDefaultLocale) {
          core.environment = {
            sessionVariables = {
              LANG = customCfg.mainLocale;
              LANGUAGE = "${customCfg.mainLocale}:${config.i18n.defaultLocale}:en:C";
            };
          };
        })

        (lib.mkIf (customCfg.enable && customCfg.ttyForceDefaultLocale) {
          core.environment = {
            graphicalSessionVariables = {
              LANG = customCfg.mainLocale;
              LANGUAGE = "${customCfg.mainLocale}:${config.i18n.defaultLocale}:en:C";
            };
          };
        })
      ];
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customLocalizationSubmodule);
  };
}
