{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ difftastic ];
    };

    custom.applications.git = {
      config =
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
}
