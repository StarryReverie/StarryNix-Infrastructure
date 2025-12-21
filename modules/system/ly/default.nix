{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.displayManager.ly.enable = true;

  services.displayManager.ly.x11Support = false;
  services.displayManager.ly.settings = {
    animation = "matrix";
    session_log = ".local/state/ly-session.log";
  };
}
