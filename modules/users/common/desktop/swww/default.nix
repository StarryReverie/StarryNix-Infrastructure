{
  config,
  lib,
  pkgs,
  ...
}:
let
  customSwwwSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.desktop.swww;
    in
    {
      options.desktop.swww = {
        wallpaperPath = lib.mkOption {
          type = lib.types.str;
          description = "Path to the wallpaper file or directory";
          example = "/path/to/your/wallpaper.png";
        };

        switchingInterval = lib.mkOption {
          type = lib.types.ints.positive;
          description = ''
            The duration (in second) for which a wallpaper should display, if multiple wallpapers
            exist
          '';
          default = 300;
          example = 300;
        };

        managerPackage = lib.mkOption {
          type = lib.types.package;
          description = ''
            The manager that spawns `swww-daemon` and periodically changing the wallpaper in the
            background. (readonly)
          '';
          readOnly = true;
        };
      };

      config = lib.mkIf customCfg.enable {
        desktop.swww = {
          managerPackage = pkgs.writeShellScriptBin "swww-manager" ''
            ${pkgs.swww}/bin/swww-daemon --no-cache &
            trap "pkill swww-daemon" EXIT

            function show_image() {
              original_image="$1"
              # Showing wallpaper may fail right after the startup of the daemon
              while true; do
                ${pkgs.swww}/bin/swww img "$original_image" && break
                sleep 0.25
              done
            }

            if [ -f "${customCfg.wallpaperPath}" ]; then
              show_image "${customCfg.wallpaperPath}"
              sleep infinity
            elif [ -d "${customCfg.wallpaperPath}" ]; then
              while true; do
                for image in ${customCfg.wallpaperPath}/*.{jpg,jpeg,png,gif,bmp,tif,tiff,webp,heic,avif}; do
                  if [ -f "$image" ]; then
                    show_image "$image"
                    sleep ${builtins.toString customCfg.switchingInterval}
                  fi
                done
              done
            fi
          '';
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customSwwwSubmodule);
  };
}
