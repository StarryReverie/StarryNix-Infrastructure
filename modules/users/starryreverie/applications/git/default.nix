{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/applications/git)
  ];

  users.users.starryreverie = {
    custom.git = {
      enable = true;

      config = {
        user.name = "Justin Chen";
        user.email = "42143810+StarryReverie@users.noreply.github.com";

        core.fsmonitor = true;
        feature.manyFiles = true;
      };
    };

    custom.zsh = {
      shellAliases = {
        ga = "git add . && git status";
        gd = "git diff HEAD";
        gl = "git log --pretty='format:%C(yellow)%h %C(blue)%ad %C(white)%s' --graph --date=short";
        gp = "git push";
        gpr = "git pull --rebase";
        gs = "git status";
      };
    };
  };
}
