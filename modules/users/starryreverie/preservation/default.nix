{
  config,
  lib,
  pkgs,
  ...
}:
{
  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      commonMountOptions = [
        "x-gdu.hide"
        "x-gvfs-hide"
      ];

      directories = [
        ".cache"

        # Workaround for nix-maid: If tmpfs as root is enabled, all
        # configurations managed by nix-maid need to be set up from
        # scracth after each boot. `niri.service` starts so fast that
        # `maid-activation.service` can't prepare all systemd units in time.
        # So persisting these directories helps cache all the contents, and
        # improves speed.
        # See <https://github.com/viperML/nix-maid/issues/53>.
        ".config/environment.d"
        ".config/systemd"
        ".config/user-tmpfiles.d"
        ".local/state/nix-maid"

        # Trash should be accessed via a symlink. Nautilus is incompatible with
        # a bind-mounted trash.
        {
          directory = ".local/share/Trash";
          how = "symlink";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
