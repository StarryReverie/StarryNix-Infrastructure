{ inputs, serviceConstants, ... }@args:
{
  inherit (serviceConstants) system;

  specialArgs = args;

  config =
    {
      config,
      lib,
      pkgs,
      flakeRoot,
      ...
    }:
    let
      registry = config.starrynix-infrastructure.registry;
      cluster = registry.clusters.${serviceConstants.cluster};
      node = cluster.nodes.${serviceConstants.node};
    in
    {
      imports = [
        ./service.nix
        (flakeRoot + /modules/nixos/starrynix-infrastructure/registry)
        (flakeRoot + /services/registry.nix)
        inputs.microvm.nixosModules.microvm
      ];

      users.users.root.password = "root";
      services.openssh.enable = true;
      services.openssh.settings.PermitRootLogin = "yes";

      networking.hostName = serviceConstants.hostname;
      networking.useDHCP = false;

      microvm.hypervisor = "qemu";
      microvm.vcpu = 1;
      microvm.mem = 256;

      microvm.shares = inputs.nixpkgs.lib.singleton {
        proto = "virtiofs";
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      };

      microvm.interfaces = inputs.nixpkgs.lib.singleton {
        type = "tap";
        id = node.networkInterface;
        mac = node.macAddress;
      };

      networking.useNetworkd = true;

      systemd.network.enable = true;
      systemd.network.networks."20-lan" = {
        matchConfig.MACAddress = node.macAddress;
        address = [ node.ipv4AddressCidr ];
        networkConfig.Gateway = cluster.gatewayIpv4Address;
        networkConfig.DNS = "8.8.8.8";
      };
    };
}
