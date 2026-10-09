{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "entanglement";
  system.stateVersion = "26.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINCmdtWeZBZF20P7uz4hj9JGEo046bcHGCGWF5A3lN7w";

  custom.system = {
    applications = {
      firefox.enable = true;
    };
    core = {
      ephemeralRootfs.enable = true;
      etcOverlay.enable = true;
      fhsCompatibility.enable = true;
      initrd.enable = true;
      nix.enable = true;
      userManagement.enable = true;
    };
    desktop = {
      desktopEssentials.enable = true;
      environment-niri.enable = true;
      font.enable = true;
    };
    hardware = {
      bluetooth.enable = true;
      cpuScheduler.enable = true;
      graphicsDriver-intel.enable = true;
      keyMapper.enable = true;
      networking.enable = true;
      oomKiller.enable = true;
      powerManagement.enable = true;
      sound.enable = true;
      wireless.enable = true;
      zramSwap.enable = true;
    };
    security = {
      fail2ban.enable = true;
      sudo.enable = true;
    };
    services = {
      dconf.enable = true;
      dnsproxy.enable = true;
      ly.enable = true;
      openssh.enable = true;
      selector4nix.enable = true;
      sshAgent.enable = true;
      tailscale.enable = true;
      transparentProxy.enable = true;
    };
  };
}
