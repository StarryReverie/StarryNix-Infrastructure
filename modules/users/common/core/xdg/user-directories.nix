{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkUserDirectoryVars = userDirectories: {
    XDG_DESKTOP_DIR = userDirectories.desktop;
    XDG_DOCUMENTS_DIR = userDirectories.documents;
    XDG_DOWNLOAD_DIR = userDirectories.download;
    XDG_MUSIC_DIR = userDirectories.music;
    XDG_PICTURES_DIR = userDirectories.pictures;
    XDG_PUBLICSHARE_DIR = userDirectories.publicShare;
    XDG_TEMPLATES_DIR = userDirectories.templates;
    XDG_VIDEOS_DIR = userDirectories.videos;
  };

  customXdgSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name};
      customCfg = selfCfg.core.xdg;
    in
    {
      options.core.xdg.userDirectories = {
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

      config = lib.mkIf customCfg.enable {
        core.environment = {
          sessionVariables = mkUserDirectoryVars customCfg.userDirectories;
        };
      };
    };

  customXdgEffectSubmodule =
    { name, ... }:
    let
      selfCfg = config.custom.users.${name} or { };
      customCfg = selfCfg.core.xdg or { };
    in
    {
      config = lib.mkIf (customCfg.enable or false) {
        maid =
          let
            userDirectoryVars = mkUserDirectoryVars customCfg.userDirectories;
          in
          {
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
              wantedBy = [ config.users.users.${name}.maid.maid.systemdTarget ];
            };
          };
      };
    };
in
{
  options.custom.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customXdgSubmodule);
  };

  options.users.users = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule customXdgEffectSubmodule);
  };
}
