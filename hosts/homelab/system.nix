{
  config,
  lib,
  pkgs,
  inputs,
  constants,
  flakeRoot,
  ...
}:
{
  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.${constants.username} = {
    isNormalUser = true;
    shell = config.wrapping.packages.zsh;
    extraGroups = [ "wheel" ];

    packages =
      (with pkgs; [
        difftastic
        htop
        zoxide
      ])
      ++ (builtins.attrValues config.wrapping.packages);

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  environment.systemPackages = with pkgs; [
    socat
    dig
  ];

  programs.tcpdump.enable = true;

  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
