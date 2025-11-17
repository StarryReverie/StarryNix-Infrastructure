{
  config,
  lib,
  pkgs,
  ...
}:
let
  difftasticExecutable = lib.getExe (config.wrappers.difftastic.wrapped or pkgs.difftastic);
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
