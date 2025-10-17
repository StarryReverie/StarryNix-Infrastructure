{
  config,
  lib,
  pkgs,
  constants,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.substituters = [
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
    "https://nix-community.cachix.org"
  ];

  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  users.users.starryreverie = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      tree
      git
      neofetch
      ripgrep
      htop
      bat
      fzf
      atuin
      zellij
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  services.openssh.enable = true;
  services.v2raya.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "25.05";
}
