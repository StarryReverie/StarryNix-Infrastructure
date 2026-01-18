{
  config,
  lib,
  pkgs,
  ...
}:
{
  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [
        "desktop"
        "downloads"
        "public"
        "userdata"
        "vm"
      ];
    };
  };
}
