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

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfMp8TSE9+MYV4dPMxt9fDzA+gvowO7BkFimhpJ1k5I starryreverie@entanglement"
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
      htop.enable = true;
      keepassxc.enable = true;
      lazygit.enable = true;
      mpv.enable = true;
      nautilus.enable = true;
      qq.enable = true;
      resources.enable = true;
      rufin.enable = true;
      telegram-desktop.enable = true;
      vscode.enable = true;
      yazi.enable = true;
      zellij.enable = true;
      zsh.enable = true;
    };
    core = {
      environment.enable = true;
      ephemeralRootfs.enable = true;
      xdg.enable = true;
    };
    desktop = {
      clipboard.enable = true;
      environment-niri.enable = true;
      inputMethod.enable = true;
      launcher.enable = true;
      notification.enable = true;
      screenLocker.enable = true;
      taskbar.enable = true;
      theme-gtk.enable = true;
      theme-qt.enable = true;
      wallpaper.enable = true;
    };
    development = {
      rust.enable = true;
    };
    hardware = {
      sound.enable = true;
      wireless.enable = true;
    };
    programs = {
      bat.enable = true;
      difftastic.enable = true;
      direnv.enable = true;
      eza.enable = true;
      fastfetch.enable = true;
      fd.enable = true;
      fzf.enable = true;
      glow.enable = true;
      nixTools.enable = true;
      ripgrep.enable = true;
      stinkpot.enable = true;
      textTools.enable = true;
      zoxide.enable = true;
    };
    security = {
      password.enable = true;
    };
  };
}
