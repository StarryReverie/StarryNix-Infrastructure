{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.services.openssh;
in
{
  config = lib.mkIf customCfg.enable {
    services.openssh.enable = true;

    services.openssh.settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      KbdInteractiveAuthentication = false;
      MaxAuthTries = 3;
      TCPKeepAlive = false;
      PermitTunnel = false;
      X11Forwarding = false;
      AllowTcpForwarding = false;
      AllowAgentForwarding = true;
      LogLevel = "VERBOSE";
    };

    security.pam.sshAgentAuth.enable = true;

    preservation.preserveAt."/nix/persistence" = {
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
  };
}
