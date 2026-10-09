{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  config = lib.mkMerge [
    # Bootloader
    {
      boot.loader.efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };

      boot.loader.systemd-boot.enable = true;
    }

    # Initrd
    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
        "usb_storage"
        "vmd"
        "xhci_pci"
      ];
      boot.initrd.kernelModules = [ ];
    }

    # Kernel
    {
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
    }
  ];
}
