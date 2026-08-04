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
      vaultix.secrets."10-ens18.network" = {
        file = ./10-ens18.network.age;
        owner = "systemd-network";
        group = "systemd-network";
      };

      environment.etc."systemd/network/10-ens18.network" = {
        source = config.vaultix.secrets."10-ens18.network".path;
      };
    }
  ];
}
