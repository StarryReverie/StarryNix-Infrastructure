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
    (userModuleRoot + /applications/alacritty)
    (userModuleRoot + /applications/firefox)
    (userModuleRoot + /applications/git)
    (userModuleRoot + /applications/github-copilot-cli)
    (userModuleRoot + /applications/helix)
    (userModuleRoot + /applications/keepassxc)
    (userModuleRoot + /applications/lazygit)
    (userModuleRoot + /applications/lx-music-desktop)
    (userModuleRoot + /applications/mpv)
    (userModuleRoot + /applications/nautilus)
    (userModuleRoot + /applications/opencode)
    (userModuleRoot + /applications/qq)
    (userModuleRoot + /applications/resources)
    (userModuleRoot + /applications/telegram-desktop)
    (userModuleRoot + /applications/vscode)
    (userModuleRoot + /applications/yazi)
    (userModuleRoot + /applications/zellij)
    (userModuleRoot + /applications/zsh)
    (userModuleRoot + /core/environment)
    (userModuleRoot + /core/preservation)
    (userModuleRoot + /core/xdg)
    (userModuleRoot + /desktop/clipboard)
    (userModuleRoot + /desktop/fcitx5)
    (userModuleRoot + /desktop/gtk-theme)
    (userModuleRoot + /desktop/hyprlock)
    (userModuleRoot + /desktop/niri-environment)
    (userModuleRoot + /desktop/qt-theme)
    (userModuleRoot + /desktop/rofi)
    (userModuleRoot + /desktop/swaync)
    (userModuleRoot + /desktop/waybar)
    (userModuleRoot + /desktop/wpaperd)
    (userModuleRoot + /hardware/pipewire)
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
    (userModuleRoot + /security/password)
    (userModuleRoot + /services/mpd-ecosystem)

    # Host-specific user modules
    ./core.nix
    ./desktop.nix
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

  custom.users.starryreverie = {
    applications = {
      alacritty.enable = true;
      firefox.enable = true;
      git.enable = true;
      github-copilot-cli.enable = true;
      helix.enable = true;
      keepassxc.enable = true;
      lazygit.enable = true;
      lx-music-desktop.enable = true;
      mpv.enable = true;
      nautilus.enable = true;
      opencode.enable = true;
      qq.enable = true;
      resources.enable = true;
      telegram-desktop.enable = true;
      vscode.enable = true;
      yazi.enable = true;
      zellij.enable = true;
      zsh.enable = true;
    };
  };
}
