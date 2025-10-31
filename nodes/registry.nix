{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [ (flakeRoot + /modules/nixos/starrynix-infrastructure/registry) ];

  starrynix-infrastructure.registry.clusters = {
    "jellyfin" = {
      index = 1;
      nodes."main".index = 1;
    };

    "nextcloud" = {
      index = 2;
      nodes."main".index = 1;
      nodes."storage".index = 2;
      nodes."cache".index = 3;
    };
  };

  starrynix-infrastructure.registry.clusters = {
    "jellyfin".nodes = {
      "main".sshKey = {
        mount = true;
        type = "ed25519";
        publicKeyFile = flakeRoot + /nodes/jellyfin/main/ssh-keys/ed25519.pub;
        encryptedPrivateKeyFile = flakeRoot + /nodes/jellyfin/main/ssh-keys/ed25519.age;
      };
    };

    "nextcloud".nodes = {
      "main".sshKey = {
        mount = true;
        type = "ed25519";
        publicKeyFile = flakeRoot + /nodes/nextcloud/main/ssh-keys/ed25519.pub;
        encryptedPrivateKeyFile = flakeRoot + /nodes/nextcloud/main/ssh-keys/ed25519.age;
      };

      "storage".sshKey = {
        mount = true;
        type = "ed25519";
        publicKeyFile = flakeRoot + /nodes/nextcloud/storage/ssh-keys/ed25519.pub;
        encryptedPrivateKeyFile = flakeRoot + /nodes/nextcloud/storage/ssh-keys/ed25519.age;
      };

      "cache".sshKey = {
        mount = true;
        type = "ed25519";
        publicKeyFile = flakeRoot + /nodes/nextcloud/cache/ssh-keys/ed25519.pub;
        encryptedPrivateKeyFile = flakeRoot + /nodes/nextcloud/cache/ssh-keys/ed25519.age;
      };
    };
  };

  starrynix-infrastructure.registry.secret = {
    masterIdentities = [
      {
        identity = flakeRoot + /secrets/identities/main.key.age;
        pubkey = "age1ke6r2945sh89e6kax2myzahaedwk7647wq4kjn7luwgqg4rgduhsyggmxm";
      }
    ];
    localStorageDir = flakeRoot + /secrets/rekeyed/nodes;
  };
}
