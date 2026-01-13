{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;

  systemd.user.services."niri" = {
    # Niri ships with a `niri.service` unit, so the configuration here is
    # actually a drop-in override. Environment variables here should be forced
    # to be `{ }`, otherwise a default `PATH` for services is injected here,
    # clearing all inherited paths and making the WM totally unuseable without
    # `/run/current-system/sw/bin`, `/etc/profiles/per-user/<username>/bin` and
    # potentially other paths.
    environment = lib.mkForce { };
    bindsTo = [
      "graphical-session.target"
      "niri-session.target"
    ];
    before = [
      "graphical-session.target"
      "niri-session.target"
    ];
  };

  systemd.user.targets."niri-session" = {
    description = "Current Niri graphical user session";
    documentation = [ "man:systemd.special(7)" ];
    requires = [ "basic.target" ];
    unitConfig.RefuseManualStart = true;
    unitConfig.StopWhenUnneeded = true;
  };

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
}
