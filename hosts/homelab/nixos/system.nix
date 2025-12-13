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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHhBWBm0pl855WnAlKB6567DR3fzAWPYAbYI4YxmYFu starryreverie@starrynix-workstation"
  ];

  users.users.${constants.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBHhBWBm0pl855WnAlKB6567DR3fzAWPYAbYI4YxmYFu starryreverie@starrynix-workstation"
    ];
  };

  programs.zsh.enable = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
