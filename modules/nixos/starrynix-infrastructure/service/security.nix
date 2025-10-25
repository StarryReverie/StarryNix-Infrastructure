{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.starrynix-infrastructure.service;
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
        KexAlgorithms = [
          "curve25519-sha256@libssh.org"
          "ecdh-sha2-nistp521"
          "ecdh-sha2-nistp384"
          "ecdh-sha2-nistp256"
          "diffie-hellman-group-exchange-sha256"
        ];
        Ciphers = [
          "chacha20-poly1305@openssh.com"
          "aes256-gcm@openssh.com"
          "aes128-gcm@openssh.com"
          "aes256-ctr"
          "aes192-ctr"
          "aes128-ctr"
        ];
        Macs = [
          "hmac-sha2-512-etm@openssh.com"
          "hmac-sha2-256-etm@openssh.com"
          "umac-128-etm@openssh.com"
          "hmac-sha2-512"
          "hmac-sha2-256"
          "umac-128@openssh.com"
        ];
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
