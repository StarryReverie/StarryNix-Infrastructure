{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.mutableUsers = false;
  services.userborn.enable = true;
}
