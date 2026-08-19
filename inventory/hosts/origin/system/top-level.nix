{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "origin";
  system.stateVersion = "26.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  vaultix.settings.hostPubkey = builtins.readFile ./keys/ed25519.pub;

  boot.postBootCommands = lib.mkForce "";

  custom.system = {
    core = {
      ephemeralRootfs.enable = true;
      etcOverlay.enable = true;
      initrd.enable = true;
      nix.enable = true;
      userManagement.enable = true;
    };
    hardware = {
      console.enable = true;
      networking.enable = true;
      noSuspend.enable = true;
      zramSwap.enable = true;
    };
    services = {
      openssh.enable = true;
      selector4nix.enable = true;
    };
  };
}
