{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.csl or { };
  customCfg = selfCfg.core.preservation or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    preservation.preserveAt."/nix/persistence" = {
      users.csl = {
        commonMountOptions = [
          "x-gdu.hide"
          "x-gvfs-hide"
        ];

        directories = [
          ".cache"
          ".local/state/nix-maid"

          {
            directory = ".local/share/Trash";
            # Trash should be accessed via a symlink. Nautilus is incompatible
            # with a bind-mounted trash.
            how = "symlink";
          }
          {
            directory = ".ssh";
            mode = "0700";
          }
        ];
      };
    };
  };
}
