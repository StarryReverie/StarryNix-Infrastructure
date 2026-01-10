{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/environment)
  ];

  users.users.starryreverie = {
    custom.environment = {
      enable = true;
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [ ".config/environment.d" ];
    };
  };
}
