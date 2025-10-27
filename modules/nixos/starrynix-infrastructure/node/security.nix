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
    users.mutableUsers = false;

    users.users.test = lib.mkIf cfg.remote.enable {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = cfg.remote.hashedPassword;
      openssh.authorizedKeys.keys = cfg.remote.authorizedKeys;
    };

    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        PermitTunnel = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        MaxAuthTries = 3;
        TCPKeepAlive = false;
        AllowTcpForwarding = false;
        AllowAgentForwarding = false;
        LogLevel = "VERBOSE";
      };
    };

    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";

      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64 128 256";
        maxtime = "168h";
        overalljails = true;
      };
    };

    networking.firewall.enable = true;
    networking.nftables.enable = true;
  };
}
