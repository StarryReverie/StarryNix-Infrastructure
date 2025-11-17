{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.difftastic.basePackage = pkgs.difftastic;

  settings.git.config =
    let
      difftasticExecutable = lib.getExe config.wrappers.difftastic.wrapped;
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
}
