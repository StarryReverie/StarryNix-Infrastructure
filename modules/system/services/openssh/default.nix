{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.openssh.enable = true;

  services.openssh.settings = {
    PasswordAuthentication = false;
    PermitRootLogin = "prohibit-password";
    PermitTunnel = false;
    KbdInteractiveAuthentication = false;
    X11Forwarding = false;
    MaxAuthTries = 3;
    TCPKeepAlive = false;
    AllowTcpForwarding = false;
    AllowAgentForwarding = false;
    LogLevel = "VERBOSE";
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

  preservation.preserveAt."/nix/persistence" = {
    directories = [
      "/var/lib/fail2ban"
    ];

    files = [
      {
        file = "/etc/ssh/ssh_host_rsa_key";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_rsa_key.pub";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
      {
        file = "/etc/ssh/ssh_host_ed25519_key.pub";
        how = "symlink";
        inInitrd = true;
        configureParent = true;
      }
    ];
  };
}
