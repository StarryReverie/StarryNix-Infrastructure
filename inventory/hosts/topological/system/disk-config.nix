{
  # FIXME: After the next time deploying the system from scratch, remove
  # hard-coded `/dev/disk/by-uuid/<uuid>` to leverage disk labels, and add a
  # separate btrfs subvolume `@var`, mounted as `/nix/persistence/var`.
  disko.devices.disk.main = {
    device = "/dev/disk/by-id/nvme-Acer_SSD_N3500_512GB_ASAI35210500982";
    type = "disk";
    content.type = "gpt";

    content.partitions.esp = {
      name = "ESP";
      size = "512M";
      type = "EF00";

      content = {
        type = "filesystem";
        format = "vfat";
        device = "/dev/disk/by-uuid/7BEB-AB12";
        mountpoint = "/efi";
        mountOptions = [ "fmask=0077,dmask=0077" ];
      };
    };

    content.partitions.persistence = {
      name = "PERSISTENCE";
      size = "100%";

      content = {
        type = "btrfs";
        device = "/dev/disk/by-uuid/9f829809-7a87-42c4-aca1-fc9ada0709de";
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

  swapDevices = [
    { device = "/dev/disk/by-uuid/fd164910-91cf-4216-9605-d9f2248bb0cb"; }
  ];

  services.fstrim.enable = true;
}
