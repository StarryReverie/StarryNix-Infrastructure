{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
let
  customGitSubmodule =
    { name, ... }:
    {
      options.custom.git = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = "Whether to enable git";
          default = false;
          example = true;
        };

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

      config =
        let
          customCfg = config.users.users.${name}.custom;
        in
        {
          maid = lib.mkIf customCfg.git.enable {
            packages = with pkgs; [ git ];

            file.home.".gitconfig".text = lib.generators.toGitINI customCfg.git.config;
          };
        };
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule customGitSubmodule);
    };
  };

  config = {
    users.users.${constants.username} = {
      custom = {
        git = {
          enable = true;

          config = {
            user = {
              inherit (constants) name email;
            };
          };
        };

        zsh.shellAliases = {
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
