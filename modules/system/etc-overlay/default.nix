{
  config,
  lib,
  pkgs,
  ...
}:
{
  system.etc.overlay.enable = true;
  # Immutable etc overlay even prevents preservation from working.
  system.etc.overlay.mutable = true;

  assertions = lib.singleton {
    assertion = config.system.etc.overlay.enable -> config.preservation.enable;
    message =  ''
      Content in the old `/etc` will be ignored after etc overlay is enabled.
      Preservation should be enabled to link or bind-mount essential files (e.g.
      SSH keys) from a persistent storage to `/etc`.
    '';
  };
}
