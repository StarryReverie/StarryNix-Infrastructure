{
  config,
  lib,
  pkgs,
  constants,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/nixos/nix)
    ./hardware.nix
    ./networking.nix
  ];

  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.starryreverie = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      htop
      zellij
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  programs.zsh.enable = true;

  services.openssh.enable = true;
  services.v2raya.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "25.05";
}
