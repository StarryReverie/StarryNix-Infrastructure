{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "interference";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Hong_Kong";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ7Sondk+b5QIot+iua5gQ1lSC2GLpb7RPq5m6rileH";

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
      zram-swap.enable = true;
    };
    security = {
      fail2ban.enable = true;
      secret.enable = true;
      sudo.enable = true;
    };
    services = {
      openssh.enable = true;
      tailscale.enable = true;
    };
  };
}
