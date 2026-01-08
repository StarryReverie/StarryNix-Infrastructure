{
  config,
  lib,
  pkgs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/xdg)
  ];

  users.users.starryreverie = {
    custom.xdg = {
      enable = true;

      userDirectories = {
        desktop = "$HOME/desktop";
        documents = "$HOME/userdata/documents";
        download = "$HOME/downloads";
        music = "$HOME/userdata/music";
        pictures = "$HOME/userdata/pictures";
        publicShare = "$HOME/public";
        templates = "$HOME/userdata/templates";
        videos = "$HOME/userdata/videos";
      };

      mimeApplications = {
        default = {
          # Web
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "text/html" = "firefox.desktop";

          # Documents
          "application/pdf" = "org.gnome.Papers.desktop";
          "application/epub+zip" = "org.gnome.Papers.desktop";
          "application/vnd.comicbook+zip" = "org.gnome.Papers.desktop";
          "application/vnd.comicbook-rar" = "org.gnome.Papers.desktop";

          # Images
          "image/jpeg" = "org.gnome.Loupe.desktop";
          "image/png" = "org.gnome.Loupe.desktop";
          "image/gif" = "org.gnome.Loupe.desktop";
          "image/webp" = "org.gnome.Loupe.desktop";
          "image/svg+xml" = "org.gnome.Loupe.desktop";
          "image/tiff" = "org.gnome.Loupe.desktop";
          "image/x-ms-bmp" = "org.gnome.Loupe.desktop";

          # Audio
          "audio/flac" = "io.bassi.Amberol.desktop";
          "audio/mpeg" = "io.bassi.Amberol.desktop";
          "audio/ogg" = "io.bassi.Amberol.desktop";
          "audio/wav" = "io.bassi.Amberol.desktop";
          "audio/x-wav" = "io.bassi.Amberol.desktop";
          "audio/aac" = "io.bassi.Amberol.desktop";
          "audio/x-aiff" = "io.bassi.Amberol.desktop";
          "audio/x-m4a" = "io.bassi.Amberol.desktop";

          # Video
          "video/mp4" = "io.bassi.Showtime.desktop";
          "video/x-msvideo" = "io.bassi.Showtime.desktop";
          "video/mpeg" = "io.bassi.Showtime.desktop";
          "video/x-matroska" = "io.bassi.Showtime.desktop";
          "video/quicktime" = "io.bassi.Showtime.desktop";
          "video/x-ms-wmv" = "io.bassi.Showtime.desktop";
          "video/x-flv" = "io.bassi.Showtime.desktop";
          "video/x-webm" = "io.bassi.Showtime.desktop";
          "video/webm" = "io.bassi.Showtime.desktop";

          # Text
          "text/plain" = "Helix.desktop";
          "text/markdown" = "Helix.desktop";
          "text/x-markdown" = "Helix.desktop";
          "text/css" = "Helix.desktop";
          "text/csv" = "Helix.desktop";
        };

        added = {
          "image/png" = [
            "com.github.huluti.Curtail.desktop"
            "io.gitlab.adhami3310.Converter.desktop"
          ];
          "image/jpeg" = [
            "com.github.huluti.Curtail.desktop"
            "io.gitlab.adhami3310.Converter.desktop"
          ];
          "text/plain" = [
            "codium.desktop"
            "code.desktop"
          ];
          "text/markdown" = [
            "codium.desktop"
            "code.desktop"
          ];
        };
      };
    };
  };
}
