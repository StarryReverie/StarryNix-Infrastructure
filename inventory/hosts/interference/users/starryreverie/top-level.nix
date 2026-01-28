{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    uid = 1000;
    group = config.users.groups.starryreverie.name;
    isNormalUser = true;

    extraGroups = [
      "wheel"
    ]
    ++ lib.optionals config.networking.networkmanager.enable [
      "networkmanager"
    ];

    packages = with pkgs; [
      htop
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHhBWBm0pl855WnAlKB6567DR3fzAWPYAbYI4YxmYFu starryreverie@superposition"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJFYQFEqRJVSW3kBXGRJ5QrgDYIPYl5mANwsXMmy26Ak starryreverie@DESKTOP-Q1328MM"
    ];
  };

  users.groups.starryreverie = {
    gid = config.users.users.starryreverie.uid;
  };

  custom.users.starryreverie = {
    applications = {
      git.enable = true;
      helix.enable = true;
      zsh.enable = true;
    };
    core = {
      environment.enable = true;
    };
    programs = {
      atuin.enable = true;
      bat.enable = true;
      eza.enable = true;
      fd.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
    };
    security = {
      password.enable = true;
    };
  };
}
