{
  config,
  lib,
  pkgs,
  ...
}:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "superposition";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKkfLJ1nNXoIFe33/puw/m/8ytPQhD7TYoTD2WCCl88";

  custom.system = {
    applications = {
      firefox.enable = true;
    };
    core = {
      etc-overlay.enable = true;
      fhs-compatibility.enable = true;
      initrd.enable = true;
      nix.enable = true;
      preservation.enable = true;
      user-management.enable = true;
    };
    desktop = {
      font.enable = true;
      desktop-essentials.enable = true;
      niri-environment.enable = true;
      wayfire-environment.enable = true;
    };
    hardware = {
      bluetooth.enable = true;
      intel-graphics.enable = true;
      keyd.enable = true;
      networking.enable = true;
      nvidia-graphics.enable = true;
      pipewire.enable = true;
      tlp.enable = true;
      wireless.enable = true;
      zram-swap.enable = true;
    };
    security = {
      fail2ban.enable = true;
      secret.enable = true;
      sudo.enable = true;
    };
    services = {
      dconf.enable = true;
      dnsproxy.enable = true;
      ly.enable = true;
      openssh.enable = true;
      ssh-agent.enable = true;
      tailscale.enable = true;
      transparent-proxy.enable = true;
    };
    virtualization = {
      container.enable = true;
      distrobox.enable = true;
      libvirt.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
