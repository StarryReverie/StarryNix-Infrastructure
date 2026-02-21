{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.desktop.qt-theme or { };
in
{
  config = {
    custom.users.csl = {
      core.environment = lib.mkIf (customCfg.enable or false) {
        sessionVariables = {
          QT_QPA_PLATFORMTHEME = "qt6ct:qt5ct";
        };
      };
    };

    users.users.csl.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qt6ct
        kdePackages.qtstyleplugin-kvantum
      ];

      file.xdg_config =
        let
          derivationsPkgs = inputs.starrynix-derivations.packages.${pkgs.stdenv.hostPlatform.system};
          kvlibadwaita = derivationsPkgs.kvlibadwaita.overrideAttrs {
            # Kvantum tries to modify the files directly when applying customizations
            postFixup = ''
              for file in $out/share/Kvantum/KvLibadwaita/*.kvconfig; do
                substituteInPlace $file --replace-fail 'tooltip_delay=0' 'tooltip_delay=-1'
              done
            '';
          };
        in
        {
          "Kvantum/KvLibadwaita".source = "${kvlibadwaita}/share/Kvantum/KvLibadwaita";

          "Kvantum/kvantum.kvconfig".text = ''
            [General]
            theme = KvLibadwaitaDark
          '';

          "qt5ct/qt5ct.conf".source = pkgs.replaceVars ./qt5ct.conf {
            colorSchemePath = pkgs.libsForQt5.qt5ct + /share/qt5ct/colors/darker.conf;
            iconTheme = "Adwaita";
            style = "kvantum-dark";
            font = "Open Sans";
          };

          "qt6ct/qt6ct.conf".source = pkgs.replaceVars ./qt6ct.conf {
            colorSchemePath = pkgs.kdePackages.qt6ct + /share/qt6ct/colors/darker.conf;
            iconTheme = "Adwaita";
            style = "kvantum-dark";
            font = "Open Sans";
          };
        };
    };
  };
}
