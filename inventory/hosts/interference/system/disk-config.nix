{
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-WDC_PC_SN520_SDAPMUW-256G-1101_190916443204";
    type = "disk";
    content.type = "gpt";

    content.partitions.esp = {
      name = "ESP";
      size = "512M";
      type = "EF00";
      priority = 1;

      content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/efi";
        mountOptions = [ "fmask=0077,dmask=0077" ];
      };
    };

    content.partitions.persistence = {
      name = "PERSISTENCE";
      size = "100%";
      priority = 2;

      content = {
        type = "btrfs";
        extraArgs = [ "-f" ];

        subvolumes."@nix" = {
          mountpoint = "/nix";
          mountOptions = [ "compress=zstd,noatime" ];
        };

        subvolumes."@rootfs" = {
          mountpoint = "/nix/persistence";
          mountOptions = [ "compress=zstd,noatime" ];
        };

        subvolumes."@home" = {
          mountpoint = "/nix/persistence/home";
          mountOptions = [ "compress=zstd,noatime" ];
        };

        subvolumes."@var" = {
          mountpoint = "/nix/persistence/var";
          mountOptions = [ "compress=zstd,noatime" ];
        };
      };
    };
  };

  disko.devices.nodev."/" = {
    fsType = "tmpfs";
    mountOptions = [ "mode=755,noatime" ];
  };

  # Disko can't configure extra mount options properly. Some critical effects
  # are applied only if these options are set in `fileSystems.<name>`.
  fileSystems."/nix" = {
    neededForBoot = true;
  };

  fileSystems."/nix/persistence" = {
    depends = [ "/nix" ];
    neededForBoot = true;
  };

  fileSystems."/nix/persistence/home" = {
    depends = [ "/nix/persistence" ];
  };

  fileSystems."/nix/persistence/var" = {
    depends = [ "/nix/persistence" ];
    neededForBoot = true;
  };

  swapDevices = [ ];
}
