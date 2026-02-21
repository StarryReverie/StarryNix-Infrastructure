{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.resources or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = with pkgs; [ resources ];

      gsettings.settings = {
        net.nokyan.Resources = {
          base = "Binary";
          show-logical-cpus = true;
          sidebar-description = true;
          sidebar-details = true;
          processes-show-drive-read-speed = true;
          processes-show-drive-write-speed = true;
        };
      };
    };
  };
}
