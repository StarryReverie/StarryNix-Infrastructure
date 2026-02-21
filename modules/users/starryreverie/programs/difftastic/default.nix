{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.programs.difftastic;
in
{
  config = {
    custom.users.starryreverie = {
      applications.git = lib.mkIf customCfg.enable {
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

    users.users.starryreverie.maid = lib.mkIf customCfg.enable {
      packages = with pkgs; [ difftastic ];
    };
  };
}
