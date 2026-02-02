{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "topological";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  custom.system = {
    core = {
      etc-overlay.enable = true;
      initrd.enable = true;
      nix.enable = true;
      preservation.enable = true;
      user-management.enable = true;
    };
    hardware = {
      networking.enable = true;
      wireless.enable = true;
      zram-swap.enable = true;
    };
    security = {
      fail2ban.enable = true;
      secret.enable = true;
      sudo.enable = true;
    };
    services = {
      dnsproxy.enable = true;
      openssh.enable = true;
      tailscale.enable = true;
      transparent-proxy.enable = true;
    };
  };
}
