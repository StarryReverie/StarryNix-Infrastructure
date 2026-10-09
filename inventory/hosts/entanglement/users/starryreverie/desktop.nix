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
        file.xdg_config."kanshi/config".text = ''
          profile {
              output "eDP-1" mode 1920x1080@59.999 scale 1.5
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
