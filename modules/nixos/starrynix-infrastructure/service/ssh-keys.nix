{
  config,
  lib,
  pkgs,
  ...
}:
let
  keyCfg = config.starrynix-infrastructure.service.nodeInformation.sshKey;
in
{
  config = {
    services.openssh.hostKeys = lib.mkIf keyCfg.mount [
      {
        inherit (keyCfg) type;
        path = "/etc/ssh/ssh_host_${keyCfg.type}_key";
      }
    ];

    fileSystems."/etc/ssh/ssh_host_${keyCfg.type}_key.pub" = lib.mkIf keyCfg.mount {
      device = "${keyCfg.publicKeyFile}";
      fsType = "none";
      options = [
        "bind"
        "ro"
      ];
    };

    fileSystems."/etc/ssh/ssh_host_${keyCfg.type}_key" = lib.mkIf keyCfg.mount {
      depends = [ "/etc/ssh/mount" ];
      device = "/etc/ssh/mount/ssh_host_${keyCfg.type}_key";
      fsType = "none";
      options = [
        "bind"
        "ro"
      ];
    };

    systemd.services."agenix-install-secrets" = {
      unitConfig.RequiresMountsFor = "/etc/ssh/ssh_host_${keyCfg.type}_key";
    };
  };
}
