{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.virtualization.libvirt or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie = {
      extraGroups = [ "libvirtd" ];
    };
  };
}
