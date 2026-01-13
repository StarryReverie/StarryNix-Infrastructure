{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  resourcesPkgs = inputs.starrynix-resources.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  wallpaperPackage = resourcesPkgs.wallpaperPackages.minimalism;
in
{
  users.users.starryreverie.maid = {
    packages = with pkgs; [ hyprlock ];

    file.xdg_config."hypr/hyprlock.conf".text = ''
      ${builtins.readFile ./hyprlock.template.conf}

      background {
          path = ${wallpaperPackage.wallpaperDir}/wallhaven-2y2wg6.jpg
          blur_passes = 2
          blur_size = 5
      }
    '';
  };

  security.pam.services.hyprlock = { };
}
