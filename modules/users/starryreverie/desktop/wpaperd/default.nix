{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.desktop.wpaperd or { };
in
let
  resourcesPkgs = inputs.starrynix-resources.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  wallpaperPackage = resourcesPkgs.wallpaperPackages.anime-girls;

  configFile = pkgs.writers.writeTOML "wpaperd-config.toml" {
    default = {
      path = wallpaperPackage.wallpaperDir;
      queue-size = 20;
      duration = "10m";
      transition-time = 2000;
      mode = "center";
    };
  };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ wpaperd ];

      file.xdg_config."wpaperd/config.toml".source = configFile;
    };
  };
}
