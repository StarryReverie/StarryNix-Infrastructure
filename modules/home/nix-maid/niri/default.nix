{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
let
  cfg = config.users.users.${constants.username}.maid;
in
{
  users.users.${constants.username}.maid = {
    file.xdg_config."niri/config.kdl".text = lib.mkAfter (builtins.readFile ./config.kdl);

    systemd.services.kanshi = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.kanshi}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };

    systemd.services.swaybg = {
      serviceConfig.ExecStart = "${lib.getExe pkgs.swaybg} -i /home/${constants.username}/userdata/pictures/wallpapers/2/b5757011b2a24502b9d82b99d0056a9c.jpg";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [
        "niri.service"
        cfg.systemd.services.kanshi.name
      ];
    };

    systemd.services.mako = {
      serviceConfig.ExecStart = "${lib.getExe config.wrapping.packages.mako or pkgs.mako}";
      wantedBy = [ "niri.service" ];
      partOf = [ "niri.service" ];
      after = [ "niri.service" ];
    };
  };
}
