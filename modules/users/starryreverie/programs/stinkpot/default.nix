{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.stinkpot or { };

  stinkpotPkg = pkgs.pkgsExternal.stinkpot.stinkpot;
in
{
  config = {
    custom.users.starryreverie = {
      applications.zsh = lib.mkIf (customCfg.enable or false) {
        rcContent = (
          lib.mkOrder 1150 ''
            # ===== Stinkpot integration
            # Loaded after zvm (which uses ZVM_INIT_MODE=sourcing) so this
            # ^R binding overwrites zvm's default history-incremental-search-backward.
            eval "$(${stinkpotPkg}/bin/stinkpot init zsh)"
            bindkey -M vicmd '^r' __stinkpot_search
          ''
        );
      };
    };

    users.users.starryreverie.maid = lib.mkIf (customCfg.enable or false) {
      packages = [ stinkpotPkg ];
    };

    preservation.preserveAt."/nix/persistence" = lib.mkIf (customCfg.enable or false) {
      users.starryreverie = {
        directories = [ ".local/share/stinkpot" ];
      };
    };
  };
}
