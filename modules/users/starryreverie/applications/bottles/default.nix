{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.bottles;
in
{
  config = lib.mkIf customCfg.enable {
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
