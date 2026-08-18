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

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBtaKKqMtgBWUg8Nk3IWMnPMvPoVfqdKxNHe/HAZr0Nh";

  custom.system = {
    core = {
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
