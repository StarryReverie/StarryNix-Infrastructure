{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.resources;
in
{
  config = lib.mkIf customCfg.enable {
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
