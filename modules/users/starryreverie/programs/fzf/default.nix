{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie = {
    maid = {
      packages = with pkgs; [ fzf ];
    };

    custom.applications.zsh = {
      environment = {
        FZF_DEFAULT_OPTS = builtins.concatStringsSep " " [
          "--ansi"
          "--reverse"
          "--scroll-off=5"
          "--cycle"
        ];

        FZF_DEFAULT_COMMAND = "fd --color=always .";
      };

      rcContent = ''
        # ===== Fzf integration
        function _fzf_compgen_path() {
            eval "fd ."
        }

        function _fzf_compgen_dir() {
            eval "fd --type d ."
        }

        source <(${lib.getExe pkgs.fzf} --zsh)
      '';
    };
  };

}
