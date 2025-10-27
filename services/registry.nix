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
    "web-fireworks" = {
      index = 1;
      nodes."web".index = 1;
    };
  };

  starrynix-infrastructure.registry.clusters = {
    "web-fireworks".nodes."web".sshKey = {
      mount = true;
      type = "ed25519";
      publicKeyFile = flakeRoot + /services/web-fireworks/web/ssh-keys/ed25519.pub;
      encryptedPrivateKeyFile = flakeRoot + /services/web-fireworks/web/ssh-keys/ed25519.age;
    };
  };

  starrynix-infrastructure.registry.secret = {
    masterIdentities = [
      {
        identity = flakeRoot + /secrets/identities/main.key.age;
        pubkey = "age1ke6r2945sh89e6kax2myzahaedwk7647wq4kjn7luwgqg4rgduhsyggmxm";
      }
    ];
    localStorageDir = flakeRoot + /secrets/rekeyed/services;
  };
}
