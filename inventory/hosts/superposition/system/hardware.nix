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
        "xhci_pci"
        "nvme"
        "thunderbolt"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
    }

    # Kernel
    {
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];
    }

    # Keyd
    {
      # Keyd ignores mice by default. Specific mouse device ID must be added explicitly.
      services.keyd.keyboards.default.ids = [
        # 2.4G Receiver
        "3554:fc00:dc9a6987"
        # Bluetooth 1
        "25a7:faa0:c238fbe2"
      ];
    }

    # NVIDIA Graphics
    {
      custom.system.hardware.nvidia-graphics = {
        prime = "offload";
      };

      hardware.nvidia.prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    }
  ];
}
