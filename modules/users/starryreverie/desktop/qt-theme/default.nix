{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qt6ct
        kdePackages.qtstyleplugin-kvantum
      ];

      file.xdg_config =
        let
          orchis = inputs.starrynix-derivations.packages.${pkgs.stdenv.hostPlatform.system}.orchis-kde;
        in
        {
          "Kvantum/Orchis-solid".source = "${orchis}/share/Kvantum/Orchis-solid";

          "Kvantum/kvantum.kvconfig".text = ''
            [General]
            theme = Orchis-solidDark
          '';

          "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./qt5ct.conf {
            colorSchemePath = pkgs.libsForQt5.qt5ct + /share/qt5ct/colors/darker.conf;
            iconTheme = "Reversal-dark";
            style = "kvantum-dark";
            font = "Open Sans";
          };

          "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./qt6ct.conf {
            colorSchemePath = pkgs.kdePackages.qt6ct + /share/qt6ct/colors/darker.conf;
            iconTheme = "Reversal-dark";
            style = "kvantum-dark";
            font = "Open Sans";
          };
        };
    };

    custom.core.environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct:qt5ct";
      };
    };
  };
}
