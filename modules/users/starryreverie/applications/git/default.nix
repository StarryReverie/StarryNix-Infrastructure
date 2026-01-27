{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.git;
in
{
  config = {
    custom.users.starryreverie = {
      applications.git = lib.mkIf customCfg.enable {
        config = {
          user.name = "Justin Chen";
          user.email = "42143810+StarryReverie@users.noreply.github.com";

          core.fsmonitor = true;
          feature.manyFiles = true;
        };
      };

      applications.zsh = lib.mkIf customCfg.enable {
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
  };
}
