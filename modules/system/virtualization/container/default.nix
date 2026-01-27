{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.virtualization.container;
in
{
  config = lib.mkIf customCfg.enable {
    virtualisation.oci-containers.backend = "podman";

    virtualisation.podman = {
      enable = true;
      dockerCompat = true;

      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    preservation.preserveAt."/nix/persistence" = {
      directories = [
        # OCI containers
        "/var/lib/containers"
        # LXC
        "/var/lib/lxc"
        # Systemd-nspawn containers
        "/var/lib/machines"
      ];
    };
  };
}
