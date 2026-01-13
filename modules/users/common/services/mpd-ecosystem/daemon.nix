{
  config,
  lib,
  pkgs,
  ...
}:
let
  customMpdEcosystemSubmodule =
    { name, ... }:
    {
      options.custom.mpd-ecosystem.daemon = {
        package = lib.mkPackageOption pkgs "mpd" { };

        musicDirectory = lib.mkOption {
          type = lib.types.str;
          description = ''
            Directory of the music library. `~`, `$HOME`, `$XDG_CONFIG_HOME`,
            `$XDG_MUSIC_DIR`, `$XDG_CACHE_HOME` and `$XDG_RUNTIME_DIR` can be
            recognized by MPD.
          '';
          example = "$XDG_MUSIC_DIR/library";
        };

        playlistDirectory = lib.mkOption {
          type = lib.types.str;
          description = ''
            Directory of the music playlist. `~`, `$HOME`, `$XDG_CONFIG_HOME`,
            `$XDG_MUSIC_DIR`, `$XDG_CACHE_HOME` and `$XDG_RUNTIME_DIR` can be
            recognized by MPD.
          '';
          example = "$XDG_MUSIC_DIR/playlists";
        };

        extraConfig = lib.mkOption {
          type = lib.types.lines;
          description = "Extra configuration to append";
          default = "";
          example = ''
            playlist_plugin {
                name "m3u"
                enabled "true"
            }
          '';
        };
      };

      config =
        let
          selfCfg = config.users.users.${name};
          customCfg = selfCfg.custom.mpd-ecosystem;
        in
        {
          maid = lib.mkIf customCfg.enable {
            systemd.services.mpd =
              let
                mpdConfigFile = pkgs.writeText "mpd.conf" ''
                  music_directory "${customCfg.daemon.musicDirectory}"
                  playlist_directory "${customCfg.daemon.playlistDirectory}"
                  db_file "$HOME/.local/share/mpd/db"
                  state_file "$HOME/.local/state/mpd/state"
                  sticker_file "$HOME/.local/share/mpd/sticker"

                  ${customCfg.daemon.extraConfig}
                '';

                mpdPreStart = pkgs.writeShellScriptBin "mpd-pre-start" ''
                  mkdir -p ${customCfg.daemon.musicDirectory}
                  mkdir -p ${customCfg.daemon.playlistDirectory}
                  # Unfortunately, MPD doesn't support `$XDG_DATA_HOME` and
                  # `$XDG_STATE_HOME`, but hardcoded `$HOME/.local/share` and
                  # `$HOME/.local/state` shouldn't be a significant problem, as
                  # the default is unlikely to be changed.
                  mkdir -p $HOME/.local/share/mpd
                  mkdir -p $HOME/.local/state/mpd
                '';
              in
              {
                requires = [ "mpd.socket" ];
                after = [
                  "mpd.socket"
                  "sound.target"
                ];
                serviceConfig.Type = "notify";
                serviceConfig.ExecStartPre = "${lib.getExe mpdPreStart}";
                serviceConfig.ExecStart = "${lib.getExe customCfg.daemon.package} --no-daemon ${mpdConfigFile}";
              };

            systemd.sockets.mpd = {
              wantedBy = [ "sockets.target" ];
              listenStreams = [ "%t/mpd/socket" ];
              socketConfig.Backlog = 5;
              socketConfig.KeepAlive = true;
            };
          };
        };
    };
in
{
  options = {
    users.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule customMpdEcosystemSubmodule);
    };
  };
}
