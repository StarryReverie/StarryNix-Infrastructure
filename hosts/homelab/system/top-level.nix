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
    (systemModuleRoot + /dae)
    (systemModuleRoot + /initrd)
    (systemModuleRoot + /ly)
    (systemModuleRoot + /networking)
    (systemModuleRoot + /nix)
    (systemModuleRoot + /openssh)
    (systemModuleRoot + /secret)
    (systemModuleRoot + /tailscale)
    (systemModuleRoot + /user-management)
    (systemModuleRoot + /wireless)

    # Host-specific system modules
    ./hardware.nix
    ./networking.nix
    ./service.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "starrynix-homelab";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  preservation.enable = lib.mkForce false;
}
