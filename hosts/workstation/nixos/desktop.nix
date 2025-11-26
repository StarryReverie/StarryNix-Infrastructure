{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.niri.enable = true;
  services.displayManager.ly.enable = true;

  environment.systemPackages = with pkgs; [
    keepassxc
    nautilus
    dconf-editor
    amberol
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.tailscale.enable = true;
  programs.firefox.enable = true;
}
