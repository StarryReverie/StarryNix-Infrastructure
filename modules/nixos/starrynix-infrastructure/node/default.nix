{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  stateSubmodule =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          description = "The name of this state directory";
          example = "postgresql";
        };

        mountPoint = lib.mkOption {
          type = lib.types.str;
          description = "The mount point of this state directory in the node";
          example = "/var/lib/postgresql";
        };
      };

      config = {
        name = lib.mkDefault name;
      };
    };
in
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    inputs.microvm.nixosModules.microvm
    ../registry
    ./hardware.nix
    ./networking.nix
    ./secret.nix
    ./security.nix
    ./ssh-keys.nix
    ./system.nix
  ];

  options = {
    starrynix-infrastructure.node = {
      name = {
        cluster = lib.mkOption {
          type = lib.types.str;
          description = "The name of the cluster that this node belongs to";
          example = "cluster";
        };

        node = lib.mkOption {
          type = lib.types.str;
          description = "The name of this node";
          example = "node";
        };
      };

      remote = {
        enable = lib.mkOption {
          type = lib.types.bool;
          description = ''
            Whether to enable remote SSH access to the `test` account in this
            node. Since exposing SSH access to outside of the node is dangerous,
            it's advised to use this option only when debugging your node and
            restrict login within the physical server.
          '';
          default = false;
          example = true;
        };

        hashedPassword = lib.mkOption {
          type = lib.types.str;
          description = "The hashed password for the `test` user";
          example = "$y$j9T$AYLFkrfdHkrdBU.OyTy6z/$LthuC4m.rEpTT1i/rokfwBI5nndopdKppbt8TxcK.e";
        };

        authorizedKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          description = ''
            Authorized SSH public keys to be added for thet `test` user
          '';
          default = [ ];
          example = [ "ssh-ed25519 xxxxxxxxxxx" ];
        };
      };

      states = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule stateSubmodule);
        description = "All persistent states that the node needs";
        default = { };
        example = {
          "postgresql" = {
            mountPoint = "/var/lib/postgresql";
          };
        };
      };

      clusterInformation = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = ''
          Information of the cluster that this node belongs to in the registry
          `starrynix-infrastructure.registry` (readonly)
        '';
        readOnly = true;
      };

      nodeInformation = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = ''
          Information of this node in the registry
          `starrynix-infrastructure.registry` (readonly)
        '';
        readOnly = true;
      };
    };
  };

  config =
    let
      registryCfg = config.starrynix-infrastructure.registry;
      nodeCfg = config.starrynix-infrastructure.node;
    in
    {
      starrynix-infrastructure.node = {
        clusterInformation = registryCfg.clusters.${nodeCfg.name.cluster};
        nodeInformation = nodeCfg.clusterInformation.nodes.${nodeCfg.name.node};
      };
    };
}
