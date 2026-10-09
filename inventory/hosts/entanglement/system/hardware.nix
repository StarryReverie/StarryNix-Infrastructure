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

    # Key Mapper
    {
      # Keyd ignores mice by default. Specific mouse device ID must be added explicitly.
      services.keyd.keyboards.default.ids = [
        # 2.4G Receiver
        "3554:fc00:dc9a6987"
        # Bluetooth 1
        "25a7:faa0:c238fbe2"
      ];
    }
  ];
}
