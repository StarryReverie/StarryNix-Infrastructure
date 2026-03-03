{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.swww or { };
in
{
  config = {
    custom.users.starryreverie = {
      desktop.swww = lib.mkIf (customCfg.enable or false) {
        wallpaperPath =
          let
            resourcesPkgs = inputs.starrynix-resources.legacyPackages.${pkgs.stdenv.hostPlatform.system};
            wallpaperPackage = resourcesPkgs.wallpaperPackages.anime-girls;
            wallpaperPath = "${wallpaperPackage.wallpaperDir}/haowallpaper-17799466375433600.jpg";
          in
          wallpaperPath;
      };
    };
  };
}
