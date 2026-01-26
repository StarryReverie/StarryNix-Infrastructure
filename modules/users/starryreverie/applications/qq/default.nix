{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.applications.qq;
in
{
  config = lib.mkIf customCfg.enable {
    users.users.starryreverie.maid = {
      packages = [
        (inputs.wrapper-manager.lib.wrapWith pkgs {
          basePackage = pkgs.qq;
          prependFlags = [ "--disable-gpu" ];
        })
      ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [ ".config/QQ" ];
      };
    };
  };
}
