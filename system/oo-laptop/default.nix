{ config, lib, pkgs, constants, ... }:

{
  imports = [
    # Common modules
    ../../modules/flags
    ../../modules/nixos

    # System-specific modules
    ./hardware.nix
    ./virtualization.nix
    ./secrets.nix
  ];

  networking.hostName = "oo-laptop";

  time.timeZone = "Asia/Shanghai";

  users.users.${constants.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "dialout" "docker" ];
    openssh.authorizedKeys.keys = [
      # oo-matepad
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGsW8RQD1WfSg1N0uriuTO6B10T7LMnRUMDhQiKr//G7 nix-on-droid@localhost"
    ];
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";

    # this sets the default vendor to integrated video card, which fixes slow
    # startup time of EGL-based softwares in machines with hybrid graphics
    # under Wayland.
    __EGL_VENDOR_LIBRARY_FILENAMES =
      "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
  };

  system.stateVersion = "24.05";
}

