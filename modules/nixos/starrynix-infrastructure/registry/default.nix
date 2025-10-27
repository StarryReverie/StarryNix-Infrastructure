{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.starrynix-infrastructure.registry;

  calcMacAddress =
    clusterName: nodeName:
    let
      hash = builtins.hashString "sha256" "${clusterName}-${nodeName}";
      cut = start: builtins.substring start 2 hash;
    in
    "${builtins.substring 0 1 hash}2:${cut 2}:${cut 4}:${cut 6}:${cut 8}:${cut 10}";

  nodeSubmodule =
    {
      name,
      nodeAttrsMap,
      clusterIndex,
      clusterName,
      ...
    }:
    let
      self = nodeAttrsMap.${name};
      index = self.index;
    in
    {
      options = {
        name = lib.mkOption {
          type = lib.types.strMatching "[a-zA-Z0-9_-]+";
          description = "The identifier of this service node";
          example = "web";
        };

        index = lib.mkOption {
          type = lib.types.ints.between 1 253;
          description = ''
            The unique index of this service node, which will be used in the
            node's IPv4 address
          '';
          example = 1;
        };

        sshKey = {
          mount = lib.mkOption {
            type = lib.types.bool;
            description = "Whether to mount the provided SSH key pair";
            default = false;
            example = true;
          };

          type = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            description = "The type of the SSH key pair";
            default = null;
            example = "ed25519";
          };

          publicKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            description = "The content of the SSH public key";
            default = null;
          };

          encryptedPrivateKeyFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            description = "The path to the encrypted SSH private key";
            default = null;
          };
        };

        hostName = lib.mkOption {
          type = lib.types.str;
          description = ''
            The name of this service node that will be written to
            `/etc/hostname` (readonly)
          '';
          readOnly = true;
        };

        networkInterface = lib.mkOption {
          type = lib.types.str;
          description = ''
            The name of this service node's network interface on the host's
            side (readonly)
          '';
          readOnly = true;
        };

        ipv4Address = lib.mkOption {
          type = lib.types.str;
          description = "The IPv4 address of this service node (readonly)";
          readOnly = true;
        };

        ipv4AddressCidr = lib.mkOption {
          type = lib.types.str;
          description = ''
            The IPv4 address of this service node in CIDR notation (readonly)
          '';
          readOnly = true;
        };

        macAddress = lib.mkOption {
          type = lib.types.str;
          description = ''
            The MAC address of this service node's network interface (readonly)
          '';
          readOnly = true;
        };
      };

      config =
        let
          ipv4Address = "172.25.${builtins.toString clusterIndex}.${builtins.toString index}";
        in
        {
          name = lib.mkDefault name;
          hostName = lib.mkDefault "starrynix-node-${clusterName}-${name}";
          networkInterface = lib.mkDefault "starrynix${builtins.toString clusterIndex}-${builtins.toString index}";
          ipv4Address = lib.mkDefault ipv4Address;
          ipv4AddressCidr = lib.mkDefault "${ipv4Address}/24";
          macAddress = lib.mkDefault (calcMacAddress clusterName name);
        };
    };

  clusterSubmodule =
    { name, clusterAttrsMap, ... }:
    let
      self = clusterAttrsMap.${name};
      index = self.index;
    in
    {
      options = {
        name = lib.mkOption {
          type = lib.types.strMatching "[a-zA-Z0-9_-]+";
          description = "The identifier of this service cluster";
          example = "cluster";
        };

        index = lib.mkOption {
          type = lib.types.ints.between 1 255;
          description = ''
            The unique index of this service cluster, which will be used in the
            cluster's network address
          '';
          example = 1;
        };

        nodes = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submoduleWith {
              modules = [ nodeSubmodule ];
              specialArgs = {
                nodeAttrsMap = self.nodes;
                clusterName = name;
                clusterIndex = index;
              };
            }
          );
          description = "All service nodes in this cluster";
          default = { };
        };

        networkBridge = lib.mkOption {
          type = lib.types.str;
          description = "The name of the cluster's bridge (readonly)";
          readOnly = true;
        };

        gatewayIpv4Address = lib.mkOption {
          type = lib.types.str;
          description = ''
            The IPv4 address of this cluster's subnet's gateway (readonly)
          '';
          readOnly = true;
        };

        gatewayIpv4AddressCidr = lib.mkOption {
          type = lib.types.str;
          description = ''
            The IPv4 address of this cluster's subnet's gateway in CIDR
            notation (readonly)
          '';
          readOnly = true;
        };
      };

      config =
        let
          gatewayIpv4Address = "172.25.${builtins.toString index}.254";
        in
        {
          name = lib.mkDefault name;
          networkBridge = lib.mkDefault "starrynix-br${builtins.toString index}";
          gatewayIpv4Address = lib.mkDefault gatewayIpv4Address;
          gatewayIpv4AddressCidr = lib.mkDefault "${gatewayIpv4Address}/24";
        };
    };
in
{
  options = {
    starrynix-infrastructure.registry = {
      clusters = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submoduleWith {
            modules = [ clusterSubmodule ];
            specialArgs = {
              clusterAttrsMap = cfg.clusters;
            };
          }
        );
        description = "All clusters' definition";
        default = { };
      };

      secret = {
        masterIdentities = lib.mkOption {
          type = lib.types.listOf lib.types.anything;
          description = "Master identities passed to `agenix-rekey`";
          default = [ ];
        };

        localStorageDir = lib.mkOption {
          type = lib.types.path;
          description = "Directory that stores rekeyed secrets";
        };
      };
    };
  };

  config = {
    assertions = [
      (
        let
          clusters = builtins.attrValues cfg.clusters;
          clusterIndexes = lib.lists.map (c: c.index) clusters;
          dupClusterIndexes = lib.lists.unique (
            lib.lists.filter (i: (lib.lists.count (x: x == i) clusterIndexes) > 1) clusterIndexes
          );
        in
        {
          assertion = dupClusterIndexes == [ ];
          message =
            let
              indexMsg =
                if dupClusterIndexes != [ ] then
                  "Duplicate cluster index(es): ${
                    builtins.concatStringsSep ", " (map (i: "`${builtins.toString i}`") dupClusterIndexes)
                  }."
                else
                  "";
              reason = "Each cluster in starrynix-infrastructure.registry.clusters must have a unique name and index.";
            in
            "${indexMsg} ${reason}";
        }
      )
    ]
    ++ (lib.mapAttrsToList (
      clusterName: cluster:
      let
        nodes = builtins.attrValues cluster.nodes;
        nodeIndexes = map (n: n.index) nodes;
        dupNodeIndexes = lib.lists.unique (
          lib.lists.filter (i: lib.lists.count (x: x == i) nodeIndexes > 1) nodeIndexes
        );
      in
      {
        assertion = dupNodeIndexes == [ ];
        message =
          let
            indexMsg =
              if dupNodeIndexes != [ ] then
                "Duplicate node index(es): ${
                  builtins.concatStringsSep ", " (map (i: "`${builtins.toString i}`") dupNodeIndexes)
                }."
              else
                "";
            reason = "Each node in cluster `${clusterName}`in starrynix-infrastructure.registry.clusters must have a unique name and index.";
          in
          "${indexMsg} ${reason}";
      }
    ) cfg.clusters);
  };
}
