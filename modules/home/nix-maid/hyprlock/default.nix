{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [ hyprlock ];

    file.xdg_config."hypr/hyprlock.conf".source = ./hyprlock.conf;
  };

  security.pam.services.hyprlock = { };
}
