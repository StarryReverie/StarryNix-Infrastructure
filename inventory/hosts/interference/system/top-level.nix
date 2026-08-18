{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "interference";
  system.stateVersion = "26.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIekDdEeGtrR+F/ZB27dyMtHdaiJLSWhntuW2Dl8inlT";

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
      cpuScheduler.enable = true;
      networking.enable = true;
      noSuspend.enable = true;
      oomKiller.enable = true;
      powerManagement.enable = true;
      wireless.enable = true;
      zramSwap.enable = true;
    };
    security = {
      fail2ban.enable = true;
      sudo.enable = true;
    };
    services = {
      openssh.enable = true;
      selector4nix.enable = true;
      sshAgent.enable = true;
      tailscale.enable = true;
      transparentProxy.enable = true;
    };
  };
}
