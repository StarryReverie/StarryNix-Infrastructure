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
        };
    };

    custom.environment = {
      sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt6ct:qt5ct";
        QT_STYLE_OVERRIDE = "kvantum-dark";
      };
    };
  };
}
