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
    (systemModuleRoot + /hardware/networking)
    (systemModuleRoot + /hardware/pipewire)
    (systemModuleRoot + /hardware/wireless)
    (systemModuleRoot + /security/secret)
    (systemModuleRoot + /services/dae)
    (systemModuleRoot + /services/dconf)
    (systemModuleRoot + /services/ly)
    (systemModuleRoot + /services/openssh)
    (systemModuleRoot + /services/tailscale)
    (systemModuleRoot + /virtualization/container)
    (systemModuleRoot + /virtualization/distrobox)

    # Host-specific system modules
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
