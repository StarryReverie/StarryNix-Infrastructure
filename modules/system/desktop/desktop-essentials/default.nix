{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.desktop.desktop-essentials;
in
{
  config = lib.mkIf customCfg.enable {
    # `maid-activation.service` finishes before `graphical-session-pre.target`,
    # so services dependent on a graphical environment won't run without another
    # activation.
    # See <https://github.com/viperML/nix-maid/issues/53>.
    systemd.user.services."maid-graphical-session-activation" = {
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig.Type = "oneshot";
      serviceConfig.ExecStartPre = "${lib.getExe' pkgs.systemd "systemctl"} --user daemon-reload";
      serviceConfig.ExecStart = "${lib.getExe' pkgs.systemd "systemctl"} --user restart maid-activation.service";
      serviceConfig.RemainAfterExit = true;
    };

    # `nixos-fake-graphical-session.target` breaks some default systemd targets'
    # semantics, such as `graphical-session.target`, when using most WMs.
    # See <https://github.com/viperML/nix-maid/issues/56>
    systemd.user.targets."nixos-fake-graphical-session".enable = false;
  };
}
