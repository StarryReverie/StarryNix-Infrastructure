{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.pipewire;
in
{
  config = lib.mkIf customCfg.enable {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;
  };
}
