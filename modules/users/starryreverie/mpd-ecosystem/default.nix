{
  config,
  lib,
  pkgs,
  inputs,
  flakeRoot,
  ...
}:
{
  imports = [
    (flakeRoot + /modules/users/common/mpd-ecosystem)
  ];

  users.users.starryreverie = {
    custom.mpd-ecosystem = {
      enable = true;

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
      };
    };
  };
}
