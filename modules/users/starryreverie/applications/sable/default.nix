{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.applications.sable or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [
        (pkgs.runCommandLocal "sable-desktop" { meta.mainProgram = "sable"; } ''
          mkdir -p $out/bin

          ln -s ${pkgs.writeShellScript "sable" ''
            sable_data_dir="''${XDG_DATA_HOME:-$HOME/.local/share}/moe.sable.client.electron"
            mkdir -p "$sable_data_dir"

            exec ${lib.getExe pkgs.bubblewrap} \
              --dev-bind / / \
              --bind "$sable_data_dir" "''${XDG_DATA_HOME:-$HOME/.local/share}" \
              -- ${lib.getExe pkgs.pkgsExternal.starrynix-derivations.sable-desktop}
          ''} $out/bin/sable

          ln -s ${pkgs.pkgsExternal.starrynix-derivations.sable-desktop}/share $out/share
        '')
      ];
    };

    preservation.preserveAt."/nix/persistence" = {
      users.starryreverie = {
        directories = [
          ".config/moe.sable.client.electron"
          ".local/share/moe.sable.client.electron"
        ];
      };
    };
  };
}
