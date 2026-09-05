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
  };

  users.groups.starryreverie = {
    gid = config.users.users.starryreverie.uid;
  };

  custom.users.starryreverie = {
    applications = {
      alacritty.enable = true;
      cava.enable = true;
      easyeffects.enable = true;
      firefox.enable = true;
      git.enable = true;
      helix.enable = true;
      htop.enable = true;
      keepassxc.enable = true;
      lazygit.enable = true;
      lx-music-desktop.enable = true;
      mpv.enable = true;
      nautilus.enable = true;
      opencode.enable = true;
      osu-lazer.enable = true;
      prismlauncher.enable = true;
      qq.enable = true;
      resources.enable = true;
      rufin.enable = true;
      splayer.enable = true;
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
      zoxide.enable = true;
    };
    security = {
      password.enable = true;
    };
    services = {
      mpd.enable = true;
    };
    virtualization = {
      container.enable = true;
      libvirt.enable = true;
    };
  };
}
