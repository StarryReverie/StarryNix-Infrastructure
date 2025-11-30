{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
let
  cfg = config.users.users.${constants.username}.maid;

  directories = {
    XDG_DESKTOP_DIR = "$HOME/desktop";
    XDG_DOCUMENTS_DIR = "$HOME/userdata/documents";
    XDG_MUSIC_DIR = "$HOME/userdata/music";
    XDG_PICTURES_DIR = "$HOME/userdata/pictures";
    XDG_VIDEOS_DIR = "$HOME/userdata/videos";
    XDG_TEMPLATES_DIR = "$HOME/userdata/templates";
    XDG_PUBLICSHARE_DIR = "$HOME/public";
    XDG_DOWNLOAD_DIR = "$HOME/downloads";
  };
in
{
  users.users.${constants.username} = {
    homeSessionVariables = directories;

    maid = {
      file.xdg_config."user-dirs.dirs".text =
        let
          varEntries = lib.mapAttrsToList (name: value: "${name}=\"${value}\"") directories;
          fileContent = builtins.concatStringsSep "\n" varEntries;
        in
        fileContent;

      systemd.services."create-xdg-user-dirs" = {
        script =
          let
            mapMkdirCommand = name: value: "mkdir -p \"${value}\"";
            mkdirCommands = lib.mapAttrsToList mapMkdirCommand directories;
            fileContent = builtins.concatStringsSep "\n" mkdirCommands;
          in
          fileContent;

        serviceConfig.Type = "oneshot";
        wantedBy = [ cfg.maid.systemdTarget ];
      };
    };
  };
}
