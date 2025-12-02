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
    textpieces
    newsflash
    loupe
    curtail
    switcheroo
    showtime
    eartag
    amberol
    mousai
    gnome-clocks
    gnome-calendar
    eyedropper
    keepassxc
    lx-music-desktop
    dconf-editor
    qq
  ];

  services.tailscale.enable = true;
}
