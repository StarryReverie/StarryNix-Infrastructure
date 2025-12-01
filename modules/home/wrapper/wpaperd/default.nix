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
  wrappers.wpaperd.basePackage = pkgs.wpaperd;

  wrappers.wpaperd.programs.wpaperd = {
    prependFlags = [ "--config=${configFile}" ];
  };

  wrappers.wpaperd.programs.wpaperctl = { };
}
