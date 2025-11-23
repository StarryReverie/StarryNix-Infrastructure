{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    file.xdg_config."niri/config.kdl".text = lib.mkBefore ''
      debug {
          render-drm-device "/dev/dri/renderD129"
      }
    '';
  };
}
