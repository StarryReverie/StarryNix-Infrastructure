{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.core.xdg or { };
in
{
  config = {
    custom.users.starryreverie = {
      core.xdg = lib.mkIf (customCfg.enable or false) {
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
            "image/avif" = "org.gnome.Loupe.desktop";
            "image/svg+xml" = "org.gnome.Loupe.desktop";
            "image/tiff" = "org.gnome.Loupe.desktop";
            "image/x-ms-bmp" = "org.gnome.Loupe.desktop";

            # Audio
            "audio/flac" = "mpv.desktop";
            "audio/mpeg" = "mpv.desktop";
            "audio/ogg" = "mpv.desktop";
            "audio/wav" = "mpv.desktop";
            "audio/x-wav" = "mpv.desktop";
            "audio/aac" = "mpv.desktop";
            "audio/x-aiff" = "mpv.desktop";
            "audio/x-m4a" = "mpv.desktop";

            # Video
            "video/mp4" = "mpv.desktop";
            "video/x-msvideo" = "mpv.desktop";
            "video/mpeg" = "mpv.desktop";
            "video/x-matroska" = "mpv.desktop";
            "video/quicktime" = "mpv.desktop";
            "video/x-ms-wmv" = "mpv.desktop";
            "video/x-flv" = "mpv.desktop";
            "video/x-webm" = "mpv.desktop";
            "video/webm" = "mpv.desktop";

            # Text
            "text/plain" = "dev.zed.Zed.desktop";
            "text/markdown" = "dev.zed.Zed.desktop";
            "text/x-markdown" = "dev.zed.Zed.desktop";
            "text/css" = "dev.zed.Zed.desktop";
            "text/csv" = "dev.zed.Zed.desktop";
          };

          added = {
            "image/png" = [
              "io.gitlab.adhami3310.Converter.desktop"
            ];
            "image/jpeg" = [
              "io.gitlab.adhami3310.Converter.desktop"
            ];
            "text/plain" = [
              "Helix.desktop"
              "codium.desktop"
              "code.desktop"
            ];
            "text/markdown" = [
              "Helix.desktop"
              "codium.desktop"
              "code.desktop"
            ];
          };
        };
      };
    };
  };
}
