{
  config,
  lib,
  pkgs,
  inputs,
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
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  environment.systemPackages = with pkgs; [
    socat
    dig
  ];

  programs.zsh.enable = true;
  programs.tcpdump.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.dae = {
    enable = true;
    configFile = "/etc/nixos/config.dae";
  };

  system.stateVersion = "25.05";

  microvm.autostart = [
    "web-fireworks-web"
  ];

  microvm.vms = {
    web-fireworks-web = {
      inherit (inputs.self.serviceConfigurations.web-fireworks.web) specialArgs config;
    };
  };
}
