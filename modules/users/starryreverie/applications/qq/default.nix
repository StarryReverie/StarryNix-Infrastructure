{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
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
}
