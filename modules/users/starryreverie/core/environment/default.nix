{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/core/environment)
  ];

  users.users.starryreverie = {
    custom.core.environment = {
      enable = true;
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [ ".config/environment.d" ];
    };
  };
}
