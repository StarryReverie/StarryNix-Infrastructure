{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    settings.git = {
      config = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = "Configurations in `.gitconfig`";
        default = { };
        example = {
          user = {
            name = "user";
            email = "user@example.com";
          };
        };
      };
    };
  };

  config = {
    wrappers.git.basePackage = pkgs.gitMinimal;

    wrappers.git.env = {
      GIT_CONFIG_GLOBAL.value = pkgs.writeText ".gitconfig" (lib.generators.toGitINI config.settings.git.config);
    };

    settings.git.config = {
      user = {
        inherit (import ../../../constants.nix) name email;
      };
    };

    settings.zsh.shellAliases = {
      ga = "git add . && git status";
      gd = "git diff HEAD";
      gl = "git log --pretty='format:%C(yellow)%h %C(blue)%ad %C(white)%s' --graph --date=short";
      gp = "git push";
      gpr = "git pull --rebase";
      gs = "git status";
    };
  };
}
