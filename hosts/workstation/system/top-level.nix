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
    (systemModuleRoot + /bluetooth)
    (systemModuleRoot + /container)
    (systemModuleRoot + /dae)
    (systemModuleRoot + /distrobox)
    (systemModuleRoot + /etc-overlay)
    (systemModuleRoot + /font)
    (systemModuleRoot + /initrd)
    (systemModuleRoot + /ly)
    (systemModuleRoot + /networking)
    (systemModuleRoot + /nix)
    (systemModuleRoot + /pipewire)
    (systemModuleRoot + /preservation)
    (systemModuleRoot + /openssh)
    (systemModuleRoot + /secret)
    (systemModuleRoot + /tailscale)
    (systemModuleRoot + /user-management)
    (systemModuleRoot + /wireless)

    # Host-specific system modules
    ./desktop.nix
    ./hardware.nix
    ./networking.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "starrynix-workstation";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKkfLJ1nNXoIFe33/puw/m/8ytPQhD7TYoTD2WCCl88";

  nixpkgs.config.allowUnfree = true;
}
