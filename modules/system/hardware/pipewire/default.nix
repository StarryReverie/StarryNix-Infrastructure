{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;
}
