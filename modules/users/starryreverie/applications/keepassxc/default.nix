{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.keepassxc or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ keepassxc ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/keepassxc" ];
      };
    };
  };
}
