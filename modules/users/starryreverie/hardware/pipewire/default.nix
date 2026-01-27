{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.hardware.pipewire;
in
{
  # Requires corresponding system module
  imports = [ (flakeRoot + /modules/system/hardware/pipewire) ];

  config = lib.mkIf customCfg.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/state/wireplumber" ];
      };
    };
  };
}
