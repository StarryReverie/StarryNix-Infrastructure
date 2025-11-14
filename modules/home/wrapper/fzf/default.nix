{
  config,
  lib,
  pkgs,
  ...
}:
let
  fdExecutable = lib.getExe config.wrapping.packages.fd;
  fzfExecutable = lib.getExe config.wrapping.packages.fzf;
in
{
  wrappers.fzf.basePackage = pkgs.fzf;

  wrappers.fzf.env = {
    FZF_DEFAULT_OPTS.value = builtins.concatStringsSep " " [
      "--ansi"
      "--reverse"
      "--scroll-off=5"
      "--cycle"
    ];

    FZF_DEFAULT_COMMAND.value = "${fdExecutable} --color=always .";
  };

  settings.zsh.initContent = ''
    # Fzf integration
    function _fzf_compgen_path() {
        eval "${fdExecutable} ."
    }

    function _fzf_compgen_dir() {
        eval "${fdExecutable} --type d ."
    }

    source <(${fzfExecutable} --zsh)
  '';
}
