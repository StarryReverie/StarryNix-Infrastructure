{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  userModuleRoot = flakeRoot + /modules/users/starryreverie;
in
{
  imports = [
    # Common user modules
    (userModuleRoot + /core/environment)
    (userModuleRoot + /applications/git)
    (userModuleRoot + /applications/helix)
    (userModuleRoot + /applications/zsh)
    (userModuleRoot + /security/password)
    (userModuleRoot + /programs/atuin)
    (userModuleRoot + /programs/bat)
    (userModuleRoot + /programs/eza)
    (userModuleRoot + /programs/fd)
    (userModuleRoot + /programs/ripgrep)
    (userModuleRoot + /programs/zoxide)
  ];

  users.users.starryreverie = {
    uid = 1000;
    group = config.users.groups.starryreverie.name;
    isNormalUser = true;
    shell = pkgs.zsh;

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

  programs.zsh.enable = true;

  custom.users.starryreverie = {
    applications = {
      git.enable = true;
      helix.enable = true;
      zsh.enable = true;
    };
    core = {
      environment.enable = true;
    };
    security = {
      password.enable = true;
    };
  };
}
