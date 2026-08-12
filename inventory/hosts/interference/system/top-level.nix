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

  vaultix.settings.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ7Sondk+b5QIot+iua5gQ1lSC2GLpb7RPq5m6rileH";

  custom.system = {
    core = {
      ephemeralRootfs.enable = true;
      etcOverlay.enable = true;
      initrd.enable = true;
      nix.enable = true;
      userManagement.enable = true;
    };
    hardware = {
      cpuScheduler.enable = true;
      networking.enable = true;
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
