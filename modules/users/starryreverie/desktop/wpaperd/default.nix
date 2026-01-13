{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  resourcesPkgs = inputs.starrynix-resources.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  wallpaperPackage = resourcesPkgs.wallpaperPackages.landscape-illustration;

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
  users.users.starryreverie.maid = {
    packages = with pkgs; [ wpaperd ];

    file.xdg_config."wpaperd/config.toml".source = configFile;
  };
}
