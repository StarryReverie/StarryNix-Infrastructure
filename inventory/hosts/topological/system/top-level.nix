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
    (systemModuleRoot + /core/initrd)
    (systemModuleRoot + /core/nix)
    (systemModuleRoot + /core/preservation)
    (systemModuleRoot + /core/user-management)
    (systemModuleRoot + /hardware/networking)
    (systemModuleRoot + /hardware/wireless)
    (systemModuleRoot + /hardware/zram-swap)
    (systemModuleRoot + /security/fail2ban)
    (systemModuleRoot + /security/secret)
    (systemModuleRoot + /security/sudo)
    (systemModuleRoot + /services/dnsproxy)
    (systemModuleRoot + /services/openssh)
    (systemModuleRoot + /services/tailscale)
    (systemModuleRoot + /services/transparent-proxy)

    # Host-specific system modules
    ./disk-config.nix
    ./hardware.nix
    ./service.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "topological";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  custom.system = {
    core = {
      nix.enable = true;
      etc-overlay.enable = true;
      initrd.enable = true;
      preservation.enable = true;
      user-management.enable = true;
    };
    security = {
      fail2ban.enable = true;
      secret.enable = true;
      sudo.enable = true;
    };
  };
}
