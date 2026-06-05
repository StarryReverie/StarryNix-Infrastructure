{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.wallpaper or { };
in
{
  config = {
    custom.users.starryreverie = {
      desktop.wallpaper = lib.mkIf (customCfg.enable or false) {
        wallpaperPath =
          let
            resourcesPkgs = pkgs.pkgsExternal.starrynix-resources;
            wallpaperPackage = resourcesPkgs.wallpaperPackages.anime-girls;
            wallpaperPath = "${wallpaperPackage.wallpaperDir}/unknown-zhuangfangyi.jpg";
          in
          wallpaperPath;
      };
    };
  };
}
