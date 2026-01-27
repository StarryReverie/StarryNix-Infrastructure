{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.virtualization.distrobox;
in
{
  config = lib.mkIf customCfg.enable {
    environment.systemPackages = with pkgs; [
      (distrobox.overrideAttrs {
        # Distrobox hardcodes binary paths pointing to /nix/store in its
        # configuration. Once the store path of distrobox is changed, the box
        # will break.
        # See <https://github.com/89luca89/distrobox/pull/1959>.
        patches = [ ./fix-bin-path.patch ];
      })
    ];

    environment.etc."distrobox/distrobox.conf".text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro"
    '';
  };
}
