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
    core = {
      environment.enable = true;
      ephemeralRootfs.enable = true;
      localization.enable = true;
      xdg.enable = true;
    };
    hardware = {
      wireless.enable = true;
    };
    security = {
      password.enable = true;
    };
  };
}
