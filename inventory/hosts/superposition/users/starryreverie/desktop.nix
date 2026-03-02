{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Niri Environment
    {
      users.users.starryreverie.maid = {
        file.xdg_config."niri/config.kdl".text = lib.mkBefore ''
          debug {
              render-drm-device "/dev/dri/renderD129"
          }
        '';

        file.xdg_config."kanshi/config".text = ''
          profile {
            output "eDP-1" mode 2560x1440@240.000 scale 2
          }

          profile {
            output "eDP-1" disable
            output "HDMI-A-1" mode 2560x1440@144.001 scale 2
          }
        '';
      };
    }
  ];
}
