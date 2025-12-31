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
        "desktop"
        "downloads"
        "public"
        "userdata"
        "vm"

        ".cache"
        ".local/share/Trash"

        # Workaround for nix-maid: If tmpfs as root is enabled, all
        # configurations managed by nix-maid need to be set up from
        # scracth after each boot. `niri.service` starts so fast that
        # `maid-activation.service` can't prepare all systemd units in time.
        # So persisting these directories helps cache all the contents, and
        # improves speed.
        ".config/environment.d"
        ".config/systemd"
        ".config/user-tmpfiles.d"
        ".local/state/nix-maid"

        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };
}
