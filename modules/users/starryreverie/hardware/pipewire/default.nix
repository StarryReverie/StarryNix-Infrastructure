{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.hardware.pipewire or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/state/wireplumber" ];
      };
    };
  };
}
