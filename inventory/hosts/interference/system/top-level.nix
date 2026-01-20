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
    (systemModuleRoot + /security/fail2ban)
    (systemModuleRoot + /security/secret)
    (systemModuleRoot + /security/sudo)
    (systemModuleRoot + /services/openssh)
    (systemModuleRoot + /services/tailscale)

    # Host-specific system modules
    ./disk-config.nix
    ./hardware.nix
    ./networking.nix
    ./services.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  networking.hostName = "interference";
  system.stateVersion = "25.11";

  time.timeZone = "Asia/Hong_Kong";
  i18n.defaultLocale = "en_US.UTF-8";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJQ7Sondk+b5QIot+iua5gQ1lSC2GLpb7RPq5m6rileH";
}
