{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.difftastic or { };
in
{
  config = {
    custom.users.starryreverie = {
      applications.git = lib.mkIf (customCfg.enable or false) {
        settings =
          let
            difftasticExecutable = lib.getExe pkgs.difftastic;
          in
          {
            diff = {
              external = difftasticExecutable;
              tool = "difftastic";
            };

            difftool."difftastic" = {
              cmd = "${difftasticExecutable} $LOCAL $REMOTE";
            };
          };
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = with pkgs; [ difftastic ];
    };
  };
}
