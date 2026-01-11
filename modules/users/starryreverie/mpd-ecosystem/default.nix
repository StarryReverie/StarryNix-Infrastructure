{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mpdConfigFile = pkgs.writeText "mpd.conf" ''
    music_directory "$XDG_MUSIC_DIR"
    playlist_directory "$XDG_MUSIC_DIR/playlists"
    db_file "$HOME/.local/share/mpd/db"
    state_file "$HOME/.local/share/mpd/state"
    sticker_file "$HOME/.local/share/mpd/sticker.sql"
  '';

  mpdPreStart = pkgs.writeShellScriptBin "mpd-pre-start" ''
    mkdir -p ''${XDG_DATA_HOME:-$HOME/.local/share}/mpd
    mkdir -p ''${XDG_MUSIC_DIR:-$HOME/Music}/playlists
  '';
in
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [
        (inputs.wrapper-manager.lib.wrapWith pkgs {
          basePackage = pkgs.euphonica;
          env.GTK_THEME.value = null;
        })
      ];

      systemd.services.mpd = {
        requires = [ "mpd.socket" ];
        after = [
          "mpd.socket"
          "sound.target"
        ];
        serviceConfig.Type = "notify";
        serviceConfig.ExecStartPre = "${lib.getExe mpdPreStart}";
        serviceConfig.ExecStart = "${lib.getExe pkgs.mpd} --no-daemon ${mpdConfigFile}";
      };

      systemd.sockets.mpd = {
        wantedBy = [ "sockets.target" ];
        listenStreams = [ "%t/mpd/socket" ];
        socketConfig.Backlog = 5;
        socketConfig.KeepAlive = true;
      };
    };
  };
}
