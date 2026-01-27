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
      userCfg = config.custom.users.${name};
      customCfg = userCfg.applications.git;
    in
    {
      options.applications.git = {
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

  customGitEffectSubmodule =
    { name, ... }:
    let
      userCfg = config.custom.users.${name} or { };
      customCfg = userCfg.applications.git or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid = {
          packages = with pkgs; [ git ];

          file.home.".gitconfig".text = lib.generators.toGitINI customCfg.config;
        };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customGitSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customGitEffectSubmodule);
  };
}
