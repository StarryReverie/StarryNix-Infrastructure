{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.virtualization.container;
in
{
  # Requires the corresponding system module
  imports = [ (flakeRoot + /modules/system/virtualization/container) ];

  config = lib.mkIf customCfg.enable {
    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/share/containers" ];
      };
    };
  };
}
