{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.hardware.wireless;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie = {
      extraGroups = [ "networkmanager" ];
    };
  };
}
