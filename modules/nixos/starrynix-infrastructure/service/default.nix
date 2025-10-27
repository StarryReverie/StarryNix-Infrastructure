{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/nixos/secret)
    ../registry
    ./hardware.nix
    ./networking.nix
    ./security.nix
    ./ssh-keys.nix
    ./system.nix
  ];

  options = {
    starrynix-infrastructure.service = {
      name = {
        cluster = lib.mkOption {
          type = lib.types.str;
          description = "The name of the cluster that this service belongs to";
          example = "cluster";
        };

        node = lib.mkOption {
          type = lib.types.str;
          description = "The name of this service node";
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

      clusterInformation = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = ''
          Information of the cluster that this service belongs to in the
          registry `starrynix-infrastructure.registry` (readonly)
        '';
        readOnly = true;
      };

      nodeInformation = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        description = ''
          Information of this service node in the registry
          `starrynix-infrastructure.registry` (readonly)
        '';
        readOnly = true;
      };
    };
  };

  config =
    let
      registryCfg = config.starrynix-infrastructure.registry;
      serviceCfg = config.starrynix-infrastructure.service;
    in
    {
      starrynix-infrastructure.service = {
        clusterInformation = registryCfg.clusters.${serviceCfg.name.cluster};
        nodeInformation = serviceCfg.clusterInformation.nodes.${serviceCfg.name.node};
      };
    };
}
