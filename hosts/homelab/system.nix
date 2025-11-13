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
    (flakeRoot + /modules/home/wrapper/system-options.nix)
    ./hardware.nix
    ./networking.nix
    ./service.nix
  ];

  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  wrapperConfigurations = {
    inherit pkgs;
    modules = [
      (flakeRoot + /modules/home/wrapper/wrapper-options.nix)
      { wrapperConfigurations.finalPackages = config.wrapperConfigurations.finalPackages; }

      (flakeRoot + /modules/home/wrapper/atuin)
      (flakeRoot + /modules/home/wrapper/bat)
      (flakeRoot + /modules/home/wrapper/difftastic)
      (flakeRoot + /modules/home/wrapper/eza)
      (flakeRoot + /modules/home/wrapper/fastfetch)
      (flakeRoot + /modules/home/wrapper/fd)
      (flakeRoot + /modules/home/wrapper/fzf)
      (flakeRoot + /modules/home/wrapper/git)
      (flakeRoot + /modules/home/wrapper/helix)
      (flakeRoot + /modules/home/wrapper/lazygit)
      (flakeRoot + /modules/home/wrapper/ripgrep)
      (flakeRoot + /modules/home/wrapper/zellij)
      (flakeRoot + /modules/home/wrapper/zoxide)
      (flakeRoot + /modules/home/wrapper/zsh)
    ];
  };

  users.users.starryreverie = {
    isNormalUser = true;
    shell = config.wrapperConfigurations.finalPackages.zsh;
    extraGroups = [ "wheel" ];

    packages =
      (with pkgs; [
        htop
      ])
      ++ (builtins.attrValues config.wrapperConfigurations.finalPackages);

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
