{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.applications.zsh;
in
{
  config = lib.mkIf customCfg.enable {
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
      nix-zsh-completions
    ];
  };
}
