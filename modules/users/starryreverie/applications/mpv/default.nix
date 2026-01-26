{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.mpv;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie.maid = {
      packages = with pkgs; [
        (mpv.override {
          scripts = with pkgs.mpvScripts; [
            mpris
            uosc
          ];
        })
      ];

      file.xdg_config."mpv/mpv.conf".source = ./mpv.conf;
      file.xdg_config."mpv/input.conf".source = ./input.conf;
    };
  };
}
