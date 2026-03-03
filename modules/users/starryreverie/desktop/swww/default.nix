{
  config,
  lib,
  pkgs,
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
            resourcesPkgs = pkgs.pkgsExternal.starrynix-resources;
            wallpaperPackage = resourcesPkgs.wallpaperPackages.anime-girls;
            wallpaperPath = "${wallpaperPackage.wallpaperDir}/haowallpaper-17799466375433600.jpg";
          in
          wallpaperPath;
      };
    };
  };
}
