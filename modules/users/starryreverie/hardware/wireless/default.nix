{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.hardware.wireless or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie = {
      extraGroups = [ "networkmanager" ];
    };
  };
}
