{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.csl = {
    enable = true;
    uid = 1001;
    group = config.users.groups.csl.name;
    isNormalUser = true;
  };

  users.groups.csl = {
    gid = config.users.users.csl.uid;
  };

  custom.users.csl = {
    applications = {
      firefox.enable = true;
      nautilus.enable = true;
    };
    core = {
      environment.enable = true;
      localization.enable = true;
      preservation.enable = true;
      xdg.enable = true;
    };
    desktop = {
      fcitx5.enable = true;
      gtk-theme.enable = true;
      qt-theme.enable = true;
    };
    hardware = {
      pipewire.enable = true;
      wireless.enable = true;
    };
    security = {
      password.enable = true;
    };
    services = {
      dconf.enable = true;
    };
  };
}
