{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  config = lib.mkMerge [
    # Initrd
    {
      boot.initrd.availableKernelModules = [
        "ata_piix"
        "sr_mod"
        "uhci_hcd"
        "virtio_blk"
        "virtio_pci"
      ];
      boot.initrd.kernelModules = [ ];
    }

    # Kernel
    {
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
    }

    # Networking
    {
      age.secrets."10-ens18.network".rekeyFile = ./10-ens18.network.age;

      environment.etc."systemd/network/10-ens18.network" = {
        source = config.age.secrets."10-ens18.network".path;
      };
    }
  ];
}
