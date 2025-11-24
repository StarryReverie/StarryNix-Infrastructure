{
  config,
  lib,
  pkgs,
  inputs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [
      kdePackages.qtstyleplugin-kvantum
    ];

    file.xdg_config =
      let
        orchis = inputs.starrynix-derivations.packages.${pkgs.stdenv.hostPlatform.system}.orchis-kde;
      in
      {
        "Kvantum/Orchis-solid".source = "${orchis}/share/Kvantum/Orchis-solid";

        "Kvantum/kvantum.kvconfig".text = ''
          [General]
          theme = Orchis-solidDark
        '';
      };
  };
}
