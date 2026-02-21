{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.hardware.wireless or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.csl = {
      extraGroups = [ "networkmanager" ];
    };
  };
}
