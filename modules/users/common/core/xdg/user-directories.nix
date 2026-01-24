{
  config,
  lib,
  pkgs,
  ...
}:
let
  customXdgSubmodule =
    { name, ... }:
    {
      options.custom.core.xdg.userDirectories = {
        desktop = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the desktop directory";
          default = null;
          example = "$HOME/Desktop";
        };

        documents = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the documents directory";
          default = null;
          example = "$HOME/Documents";
        };

        download = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the download directory";
          default = null;
          example = "$HOME/Downloads";
        };

        music = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the music directory";
          default = null;
          example = "$HOME/Music";
        };

        pictures = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the pictures directory";
          default = null;
          example = "$HOME/Pictures";
        };

        publicShare = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the public share directory";
          default = null;
          example = "$HOME/Public";
        };

        templates = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the templates directory";
          default = null;
          example = "$HOME/Templates";
        };

        videos = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = "Path to the videos directory";
          default = null;
          example = "$HOME/Videos";
        };
      };

      config =
        let
          selfCfg = config.users.users.${name};
          customCfg = selfCfg.custom.core.xdg;

          userDirectoryVars = {
            XDG_DESKTOP_DIR = customCfg.userDirectories.desktop;
            XDG_DOCUMENTS_DIR = customCfg.userDirectories.documents;
            XDG_DOWNLOAD_DIR = customCfg.userDirectories.download;
            XDG_MUSIC_DIR = customCfg.userDirectories.music;
            XDG_PICTURES_DIR = customCfg.userDirectories.pictures;
            XDG_PUBLICSHARE_DIR = customCfg.userDirectories.publicShare;
            XDG_TEMPLATES_DIR = customCfg.userDirectories.templates;
            XDG_VIDEOS_DIR = customCfg.userDirectories.videos;
          };
        in
        lib.mkIf customCfg.enable {
          custom.core.environment = {
            sessionVariables = userDirectoryVars;
          };

          maid = {
            file.xdg_config."user-dirs.dirs".text =
              let
                varEntries = lib.mapAttrsToList (name: value: "${name}=\"${value}\"") userDirectoryVars;
                fileContent = builtins.concatStringsSep "\n" varEntries;
              in
              fileContent;

            systemd.services."create-xdg-user-dirs" = {
              script =
                let
                  mapMkdirCommand = name: value: "mkdir -p \"${value}\"";
                  mkdirCommands = lib.mapAttrsToList mapMkdirCommand userDirectoryVars;
                  fileContent = builtins.concatStringsSep "\n" mkdirCommands;
                in
                fileContent;

              serviceConfig.Type = "oneshot";
              wantedBy = [ selfCfg.maid.maid.systemdTarget ];
            };
          };
        };
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule customXdgSubmodule);
    };
  };
}
