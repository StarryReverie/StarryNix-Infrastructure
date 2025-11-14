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
      difftasticExecutable = lib.getExe config.wrapping.packages.difftastic;
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
