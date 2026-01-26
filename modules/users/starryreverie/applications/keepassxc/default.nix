{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.keepassxc;
in
{
  config = lib.mkIf customCfg.enable {
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
