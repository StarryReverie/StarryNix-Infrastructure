{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkMerge [
    # Preservation
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
  ];
}
