{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.starrynix-infrastructure.node;
in
{
  config = {
    boot.initrd.systemd.enable = true;

    networking.hostName = lib.mkDefault cfg.nodeInformation.hostName;

    microvm.hypervisor = lib.mkDefault "crosvm";
    microvm.balloon = lib.mkDefault true;
    microvm.vsock.cid = lib.mkDefault (1000 * cfg.clusterInformation.index + cfg.nodeInformation.index);

    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ]
    ++ (lib.attrsets.mapAttrsToList (_: state: {
      inherit (state) mountPoint;
      proto = "virtiofs";
      tag = state.name;
      source = state.name;
    }) cfg.states);

    microvm.binScripts.virtiofsd-run =
      let
        makeCreateDirectoryCommand =
          name: "mkdir -p /var/lib/microvms/${config.networking.hostName}/${name}";
        stateNames = lib.attrsets.mapAttrsToList (_: state: state.name) cfg.states;
        createDirectoryCommands = builtins.concatStringsSep "\n" (
          lib.lists.map makeCreateDirectoryCommand stateNames
        );
      in
      lib.mkBefore createDirectoryCommands;
  };
}
