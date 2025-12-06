{
  config,
  lib,
  pkgs,
  ...
}:
let
  difftasticExecutable = lib.getExe pkgs.difftastic;
in
{
  settings.git.config = {
    diff = {
      external = difftasticExecutable;
      tool = "difftastic";
    };

    difftool."difftastic" = {
      cmd = "${difftasticExecutable} $LOCAL $REMOTE";
    };
  };
}
