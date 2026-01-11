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
    (userModuleRoot + /alacritty)
    (userModuleRoot + /atuin)
    (userModuleRoot + /bat)
    (userModuleRoot + /clipboard)
    (userModuleRoot + /difftastic)
    (userModuleRoot + /direnv)
    (userModuleRoot + /environment)
    (userModuleRoot + /eza)
    (userModuleRoot + /fastfetch)
    (userModuleRoot + /fcitx5)
    (userModuleRoot + /firefox)
    (userModuleRoot + /fd)
    (userModuleRoot + /fzf)
    (userModuleRoot + /git)
    (userModuleRoot + /github-copilot-cli)
    (userModuleRoot + /gtk-theme)
    (userModuleRoot + /helix)
    (userModuleRoot + /hyprlock)
    (userModuleRoot + /keepassxc)
    (userModuleRoot + /lazygit)
    (userModuleRoot + /lx-music-desktop)
    (userModuleRoot + /mpd-ecosystem)
    (userModuleRoot + /niri-environment)
    (userModuleRoot + /password)
    (userModuleRoot + /pipewire)
    (userModuleRoot + /preservation)
    (userModuleRoot + /qq)
    (userModuleRoot + /qt-theme)
    (userModuleRoot + /ripgrep)
    (userModuleRoot + /rofi)
    (userModuleRoot + /swaync)
    (userModuleRoot + /telegram-desktop)
    (userModuleRoot + /vscode)
    (userModuleRoot + /waybar)
    (userModuleRoot + /wpaperd)
    (userModuleRoot + /xdg)
    (userModuleRoot + /yazi)
    (userModuleRoot + /zellij)
    (userModuleRoot + /zoxide)
    (userModuleRoot + /zsh)

    # Host-specific user modules
    ./kanshi.nix
    ./niri-environment.nix
    ./preservation.nix
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
      nixpkgs-review
    ];
  };

  users.groups.starryreverie = {
    gid = config.users.users.starryreverie.uid;
  };

  programs.zsh.enable = true;
}
