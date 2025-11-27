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
    nautilus
    papers
    newsflash
    loupe
    showtime
    eartag
    amberol
    mousai
    gnome-clocks
    gnome-calendar
    eyedropper
    keepassxc
    dconf-editor
  ];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.tailscale.enable = true;
  programs.firefox.enable = true;
}
