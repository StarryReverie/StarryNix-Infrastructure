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

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "nvme"
    "thunderbolt"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ ];

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.loader.systemd-boot.enable = true;

  services.fstrim.enable = true;

  boot.tmp.useTmpfs = true;

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva
      intel-media-driver
      linux-firmware
    ];
  };

  hardware.nvidia = {
    open = false;
    nvidiaSettings = false;
    modesetting.enable = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement = {
      enable = true;
      finegrained = true;
    };

    dynamicBoost.enable = true;
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
