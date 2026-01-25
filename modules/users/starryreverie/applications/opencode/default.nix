{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ opencode ];
    };
  };

  preservation.preserveAt."/nix/persistence" = {
    users.starryreverie = {
      directories = [
        ".config/opencode"
        ".local/share/opencode"
        ".local/state/opencode"
      ];
    };
  };
}
