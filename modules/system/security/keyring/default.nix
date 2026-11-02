{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.security.keyring;
in
{
  config = lib.mkIf customCfg.enable {
    services.gnome.gnome-keyring.enable = true;
  };
}

