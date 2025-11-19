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
  };

  services.openssh.enable = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKkfLJ1nNXoIFe33/puw/m/8ytPQhD7TYoTD2WCCl88";

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
