{
  config,
  lib,
  pkgs,
  inputs,
  flakeRoot,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie;
  customCfg = selfCfg.services.mpd-ecosystem;
in
{
  config = {
    custom.users.starryreverie = {
      services.mpd-ecosystem = lib.mkIf customCfg.enable {
        client = {
          packages = [
            (pkgs.writeShellScriptBin "mpc" ''
              uid=$(id -u $USER)
              runtime_dir=''${XDG_RUNTIME_DIR:-/run/user/$uid}
              # Mpc connects to a TCP socket by default. We force it to use a Unix
              # domain socket here.
              exec -- ${lib.getExe pkgs.mpc} --host $runtime_dir/mpd/socket "$@"
            '')

            (inputs.wrapper-manager.lib.wrapWith pkgs {
              basePackage = pkgs.euphonica;
              env.GTK_THEME.value = null;
            })
          ];
        };

        daemon = {
          musicDirectory = "$XDG_MUSIC_DIR/library";
          playlistDirectory = "$XDG_MUSIC_DIR/playlists";
          extraConfig = ''
            playlist_plugin {
              name "m3u"
              enabled "true"
            }

            restore_paused "yes"
          ''
          + lib.optionalString config.services.pipewire.enable ''
            audio_output {
              type "pipewire"
              name "PipeWire Output"
            }
          '';
        };
      };
    };

    users.users.starryreverie.maid = lib.mkIf customCfg.enable {
      gsettings.settings = {
        io.github.htkhiem.Euphonica = {
          client.mpd-use-unix-socket = true;
          client.mpd-unix-socket = "/run/user/${builtins.toString config.users.users.starryreverie.uid}/mpd/socket";
          ui.use-visualizer = false;
        };
      };
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf customCfg.enable {
      users.starryreverie = {
        directories = [
          ".local/share/mpd"
          ".local/state/mpd"
        ];
      };
    };
  };
}
