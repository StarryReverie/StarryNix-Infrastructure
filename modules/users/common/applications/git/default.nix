{
  config,
  lib,
  pkgs,
  ...
}:
let
  customGitSubmodule =
    { name, ... }:
    let
      userCfg = config.users.users.${name};
      customCfg = userCfg.custom.applications.git;
    in
    {
      options.custom.applications.git = {
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

      config = {
        maid = lib.mkIf customCfg.enable {
          packages = with pkgs; [ git ];

          file.home.".gitconfig".text = lib.generators.toGitINI customCfg.config;
        };
      };
    };
in
{
  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customGitSubmodule);
  };
}
