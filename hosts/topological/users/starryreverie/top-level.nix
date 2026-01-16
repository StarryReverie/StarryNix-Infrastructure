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
    (userModuleRoot + /applications/lazygit)
    (userModuleRoot + /applications/yazi)
    (userModuleRoot + /applications/zellij)
    (userModuleRoot + /applications/zsh)
    (userModuleRoot + /security/password)
    (userModuleRoot + /programs/atuin)
    (userModuleRoot + /programs/bat)
    (userModuleRoot + /programs/difftastic)
    (userModuleRoot + /programs/direnv)
    (userModuleRoot + /programs/eza)
    (userModuleRoot + /programs/fastfetch)
    (userModuleRoot + /programs/fd)
    (userModuleRoot + /programs/fzf)
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHhBWBm0pl855WnAlKB6567DR3fzAWPYAbYI4YxmYFu starryreverie@starrynix-workstation"
    ];
  };

  users.groups.starryreverie = {
    gid = config.users.users.starryreverie.uid;
  };

  programs.zsh.enable = true;
}
