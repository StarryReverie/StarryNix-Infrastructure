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

    # Console
    {
      console = {
        earlySetup = true;
        packages = with pkgs; [ terminus_font ];
        font = "${pkgs.terminus_font}/share/consolefonts/ter-d24b.psf.gz";
      };
    }

    # Initrd
    {
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
      boot.initrd.kernelModules = [ ];
    }

    # Kernel
    {
      boot.kernelModules = [ "kvm-amd" ];
      boot.extraModulePackages = [ ];
    }

    # Power Management
    {
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "no";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    }
  ];
}
