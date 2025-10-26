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
    (flakeRoot + /modules/nixos/secret)
    (flakeRoot + /modules/nixos/starrynix-infrastructure/host)
    (flakeRoot + /services/registry.nix)
    ./hardware.nix
    ./networking.nix
    ./secrets.nix
  ];

  networking.hostName = constants.hostname;
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.starryreverie = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHQrkIsLMV70klKFtQY8JK5QgXKGyTpZcIaLarXG5dBv"
    ];
  };

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN1iflX8DYwoguHB2BDxLy+eAcdBX+gTHEGqGNBFdvs/";

  environment.systemPackages = with pkgs; [
    socat
    dig
  ];

  console = {
    earlySetup = true;
    packages = with pkgs; [ terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-d24b.psf.gz";
  };

  programs.zsh.enable = true;
  programs.tcpdump.enable = true;

  services.openssh.enable = true;
  services.tailscale.enable = true;

  system.stateVersion = "25.11";

  starrynix-infrastructure.host = {
    deployment = {
      inherit (inputs.self) serviceConfigurations;
      enabledClusters = [ "web-fireworks" ];
    };

    networking = {
      externalInterfaces = [
        "wlp3s0"
        "tailscale0"
      ];

      forwardPorts = [
        {
          protocol = "tcp";
          sourcePort = 8080;
          toCluster = "web-fireworks";
          toNode = "web";
          destinationPort = 80;
        }
      ];
    };
  };
}
