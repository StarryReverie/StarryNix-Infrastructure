{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.hyprlock or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ hyprlock ];

      file.xdg_config."hypr/hyprlock.conf".source =
        let
          resourcesPkgs = pkgs.pkgsExternal.starrynix-resources;
          wallpaperPackage = resourcesPkgs.wallpaperPackages.minimalism;
        in
        pkgs.replaceVars ./hyprlock.conf {
          backgroundPath = "${wallpaperPackage.wallpaperDir}/wallhaven-2y2wg6.jpg";
        };
    };
  };
}
