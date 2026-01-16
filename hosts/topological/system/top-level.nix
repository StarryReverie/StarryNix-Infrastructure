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
    (systemModuleRoot + /security/fail2ban)
    (systemModuleRoot + /security/secret)
    (systemModuleRoot + /security/sudo)
    (systemModuleRoot + /services/dae)
    (systemModuleRoot + /services/ly)
    (systemModuleRoot + /services/openssh)
    (systemModuleRoot + /services/tailscale)

    # Host-specific system modules
    ./disko-config.nix
    ./hardware.nix
    ./networking.nix
    ./service.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "topological";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";
}
