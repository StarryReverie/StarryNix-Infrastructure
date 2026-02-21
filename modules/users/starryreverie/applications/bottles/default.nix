{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.bottles or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        bottles
      ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".local/share/bottles" ];
      };
    };
  };
}
