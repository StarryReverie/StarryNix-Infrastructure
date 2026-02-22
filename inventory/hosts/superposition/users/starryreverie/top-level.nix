{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    enable = true;
    uid = 1000;
    group = config.users.groups.starryreverie.name;
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      htop
      nixpkgs-review
    ];
  };

  users.groups.starryreverie = {
    gid = config.users.users.starryreverie.uid;
  };

  custom.users.starryreverie = {
    applications = {
      alacritty.enable = true;
      firefox.enable = true;
      git.enable = true;
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
    core = {
      environment.enable = true;
      preservation.enable = true;
      xdg.enable = true;
    };
    desktop = {
      clipboard.enable = true;
      fcitx5.enable = true;
      gtk-theme.enable = true;
      hyprlock.enable = true;
      niri-environment.enable = true;
      qt-theme.enable = true;
      rofi.enable = true;
      swaync.enable = true;
      waybar.enable = true;
      wayfire-environment.enable = true;
      wpaperd.enable = true;
    };
    hardware = {
      pipewire.enable = true;
      wireless.enable = true;
    };
    programs = {
      atuin.enable = true;
      bat.enable = true;
      difftastic.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      ripgrep.enable = true;
      zoxide.enable = true;
    };
    security = {
      password.enable = true;
    };
    services = {
      mpd-ecosystem.enable = true;
    };
    virtualization = {
      container.enable = true;
      libvirt.enable = true;
    };
  };
}
