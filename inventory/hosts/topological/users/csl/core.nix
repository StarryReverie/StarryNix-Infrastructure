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
        users.csl = {
          directories = [
            "desktop"
            "documents"
            "download"
            "music"
            "pictures"
            "public-share"
            "templates"
            "videos"
          ];
        };
      };
    }
  ];
}
