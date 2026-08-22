{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.core.userManagement;
in
{
  config = lib.mkIf customCfg.enable {
    users.mutableUsers = false;
    services.userborn.enable = true;
    services.userborn.passwordFilesLocation = "/var/lib/nixos";

    preservation.preserveAt."/nix/persistence" = {
      directories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];
    };
  };
}
