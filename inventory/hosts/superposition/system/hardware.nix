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

    # Graphics
    {
      services.xserver.videoDrivers = [
        "modesetting"
      ];

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          libva
          intel-media-driver
          linux-firmware
        ];
      };
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

    # Networking
    {
      services.dae = {
        wanInterfaces = [ "wlo1" ];
        forwardDns = true;
      };
    }

    # NVIDIA Graphics
    {
      custom.nvidia = {
        enable = true;
        prime = "offload";
      };

      hardware.nvidia.prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    }
  ];
}
