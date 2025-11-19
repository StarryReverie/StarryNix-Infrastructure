{ config, lib, pkgs, ... }:

let
  flags = config.flags.packages.desktop;
  hasPlasma = flags.environment.plasma.enable;

  envVars = {
    QT_QPA_PLATFORMTHEME = if hasPlasma then "kde" else "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  envVarsExtra = let
    inherit (config.home) profileDirectory;
    qtVersions = with pkgs; [ qt5 qt6 ];
    makeQtPath = prefix:
      lib.concatStringsSep ":"
      (map (qt: "${profileDirectory}/${qt.qtbase.${prefix}}") qtVersions);
  in {
    QT_PLUGIN_PATH = "$QT_PLUGIN_PATH\${QT_PLUGIN_PATH:+:}"
      + (makeQtPath "qtPluginPrefix");
    QML2_IMPORT_PATH = "$QML2_IMPORT_PATH\${QML2_IMPORT_PATH:+:}"
      + (makeQtPath "qtQmlPrefix");
  };
in {
  config = lib.mkIf flags.enable {
    home.packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
    ] ++ lib.optionals (!hasPlasma) (with pkgs; [
      qt6Packages.qt6ct
    ]);

    home.sessionVariables = envVars // envVarsExtra;

    home.sessionVariablesExtra = ''
      export QT_PLUGIN_PATH=${envVarsExtra.QT_PLUGIN_PATH}
      export QML2_IMPORT_PATH=${envVarsExtra.QML2_IMPORT_PATH}
    '';

    xsession.importedVariables = [
      "QT_QPA_PLATFORMTHEME"
      "QT_STYLE_OVERRIDE"
      "QT_PLUGIN_PATH"
      "QML2_IMPORT_PATH"
    ];
  };
}
