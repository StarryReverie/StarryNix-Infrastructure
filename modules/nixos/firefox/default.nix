{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./extensions.nix
    ./security.nix
  ];

  programs.firefox.enable = true;

  programs.firefox.preferences = {
    "browser.download.open_pdf_attachments_inline" = true;

    "media.hardware-video-decoding.forece-enabled" = true;
    "media.hardware-video-encoding.forece-enabled" = true;
  };
}
