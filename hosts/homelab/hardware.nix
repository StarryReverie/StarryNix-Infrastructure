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
    "ahci"
    "nvme"
    "usb_storage"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9f829809-7a87-42c4-aca1-fc9ada0709de";
    fsType = "btrfs";
    options = [
      "subvol=@rootfs"
      "compress=zstd"
    ];
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/7BEB-AB12";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/9f829809-7a87-42c4-aca1-fc9ada0709de";
    fsType = "btrfs";
    options = [
      "subvol=@home"
      "compress=zstd"
    ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/9f829809-7a87-42c4-aca1-fc9ada0709de";
    fsType = "btrfs";
    options = [
      "subvol=@nix"
      "compress=zstd"
      "noatime"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/fd164910-91cf-4216-9605-d9f2248bb0cb"; }
  ];

  services.fstrim.enable = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-d24b.psf.gz";
  };

  zramSwap.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault constants.system;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
