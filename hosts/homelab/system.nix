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
  imports = [
    (flakeRoot + /modules/nixos/dae)
    (flakeRoot + /modules/nixos/nix)
    (flakeRoot + /modules/nixos/openssh)
    (flakeRoot + /modules/nixos/secret)
    (flakeRoot + /nodes/registry.nix)
    ./hardware.nix
    ./networking.nix
    ./service.nix
  ];

  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.starryreverie = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];

    packages =
      let
        wrapperManagerConfigurations = inputs.wrapper-manager.lib {
          inherit pkgs;
          modules = [
            { wrappers = { }; }
            (flakeRoot + /modules/home/wrapper/bat)
            (flakeRoot + /modules/home/wrapper/fastfetch)
            (flakeRoot + /modules/home/wrapper/fd)
            (flakeRoot + /modules/home/wrapper/helix)
            (flakeRoot + /modules/home/wrapper/lazygit)
            (flakeRoot + /modules/home/wrapper/ripgrep)
            (flakeRoot + /modules/home/wrapper/zellij)
          ];
        };
      in
      (with pkgs; [
        htop
      ])
      ++ (builtins.attrValues wrapperManagerConfigurations.config.build.packages);

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  environment.systemPackages = with pkgs; [
    socat
    dig
  ];

  programs.zsh.enable = true;
  programs.tcpdump.enable = true;

  services.tailscale.enable = true;

  system.stateVersion = "25.11";
}
