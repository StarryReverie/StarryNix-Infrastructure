{
  config,
  lib,
  pkgs,
  ...
}:
let
  keyCfg = config.starrynix-infrastructure.node.nodeInformation.sshKey;
in
{
  config = {
    services.openssh.hostKeys = lib.mkIf keyCfg.mount [
      {
        inherit (keyCfg) type;
        path = "/etc/ssh/ssh_host_${keyCfg.type}_key";
      }
    ];

    fileSystems = lib.mkIf keyCfg.mount {
      "/etc/ssh/ssh_host_${keyCfg.type}_key.pub" = {
        device = "${keyCfg.publicKeyFile}";
        fsType = "none";
        options = [
          "bind"
          "ro"
        ];
      };

      "/etc/ssh/ssh_host_${keyCfg.type}_key" = {
        depends = [ "/etc/ssh/mount" ];
        device = "/etc/ssh/mount/ssh_host_${keyCfg.type}_key";
        fsType = "none";
        options = [
          "bind"
          "ro"
        ];
      };
    };

    systemd.services."agenix-install-secrets" = lib.mkIf keyCfg.mount {
      unitConfig.RequiresMountsFor = "/etc/ssh/ssh_host_${keyCfg.type}_key";
    };
  };
}
