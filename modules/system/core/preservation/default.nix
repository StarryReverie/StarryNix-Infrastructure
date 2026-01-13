{
  config,
  lib,
  pkgs,
  ...
}:
{
  preservation.enable = true;

  preservation.preserveAt."/nix/persistence" = {
    commonMountOptions = [
      "x-gdu.hide"
      "x-gvfs-hide"
    ];

    directories = [
      "/var/cache"
      "/var/db/sudo"
      "/var/lib/lastlog"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/rfkill"
      "/var/lib/systemd/timers"
      "/var/log"
    ];

    files = [
      {
        file = "/etc/machine-id";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
        createLinkTarget = true;
      }
      {
        file = "/var/lib/logrotate.status";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/var/lib/systemd/random-seed";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
    ];
  };

  boot.initrd.systemd.tmpfiles.settings = {
    preservation."/sysroot/nix/persistence/etc/machine-id".f = lib.mkIf config.preservation.enable {
      argument = "uninitialized";
    };
  };
}
