{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  systemModuleRoot = flakeRoot + /modules/system;
in
{
  imports = [
    # Common system modules
    (systemModuleRoot + /core/etc-overlay)
    (systemModuleRoot + /core/fhs-compatibility)
    (systemModuleRoot + /core/initrd)
    (systemModuleRoot + /core/nix)
    (systemModuleRoot + /core/preservation)
    (systemModuleRoot + /core/user-management)
    (systemModuleRoot + /desktop/font)
    (systemModuleRoot + /desktop/niri-environment)
    (systemModuleRoot + /hardware/bluetooth)
    (systemModuleRoot + /hardware/intel-graphics)
    (systemModuleRoot + /hardware/keyd)
    (systemModuleRoot + /hardware/networking)
    (systemModuleRoot + /hardware/nvidia-graphics)
    (systemModuleRoot + /hardware/pipewire)
    (systemModuleRoot + /hardware/tlp)
    (systemModuleRoot + /hardware/wireless)
    (systemModuleRoot + /hardware/zram-swap)
    (systemModuleRoot + /security/fail2ban)
    (systemModuleRoot + /security/secret)
    (systemModuleRoot + /security/sudo)
    (systemModuleRoot + /services/dconf)
    (systemModuleRoot + /services/dnsproxy)
    (systemModuleRoot + /services/ly)
    (systemModuleRoot + /services/openssh)
    (systemModuleRoot + /services/transparent-proxy)
    (systemModuleRoot + /services/tailscale)
    (systemModuleRoot + /virtualization/container)
    (systemModuleRoot + /virtualization/distrobox)

    # Host-specific system modules
    ./disk-config.nix
    ./hardware.nix
    ./services.nix
  ];

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
      nix.enable = true;
      etc-overlay.enable = true;
      initrd.enable = true;
      preservation.enable = true;
      user-management.enable = true;
      fhs-compatibility.enable = true;
    };
    security = {
      fail2ban.enable = true;
      secret.enable = true;
      sudo.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
