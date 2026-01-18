{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
    file.xdg_config."niri/config.kdl".text = lib.mkBefore ''
      debug {
          render-drm-device "/dev/dri/renderD129"
      }
    '';
  };
}
