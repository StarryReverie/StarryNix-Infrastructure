{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.services.ssh-agent;
in
{
  config = lib.mkIf customCfg.enable {
    programs.ssh.startAgent = !config.services.gnome.gcr-ssh-agent.enable;

    # This only takes effect when `ssh-agent` instead of `gcr-ssh-agent` is used and
    # `programs.ssh.enableAskPassword` is set to `true`.
    programs.ssh.askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
  };
}
