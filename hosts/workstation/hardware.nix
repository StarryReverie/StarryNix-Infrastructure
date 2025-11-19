{
  config,
  lib,
  pkgs,
  modulesPath,
  constants,
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
  boot.extraModulePackages = [ ];

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/256963eb-3128-441d-aa10-00be2b96b61f";
    fsType = "btrfs";
    options = [ "subvol=@rootfs,compress=zstd,noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/256963eb-3128-441d-aa10-00be2b96b61f";
    fsType = "btrfs";
    options = [ "subvol=@home,compress=zstd,noatime" ];
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/256963eb-3128-441d-aa10-00be2b96b61f";
    fsType = "btrfs";
    options = [ "subvol=@var,compress=zstd,noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/256963eb-3128-441d-aa10-00be2b96b61f";
    fsType = "btrfs";
    options = [ "subvol=@nix,compress=zstd,noatime" ];
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/6E4C-A5ED";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  services.fstrim.enable = true;

  swapDevices = [ ];

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

  nixpkgs.hostPlatform = lib.mkDefault constants.system;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
