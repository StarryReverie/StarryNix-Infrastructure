{
  config,
  lib,
  pkgs,
  ...
}:
let
  selfCfg = config.custom.users.starryreverie or { };
  customCfg = selfCfg.programs.fd or { };
in
{
  config = lib.mkIf (customCfg.enable or false) {
    users.users.starryreverie.maid = {
      packages = [ pkgs.fd ];

      file.xdg_config."fd/ignore".text = ''
        **/node_modules/**
        **/dist/**
        **/{,_}build/**
        **/target/**
        **/{,.}venv/**
        **/__pycache__/**
        **/vendor/**
        **/.gradle/**
      '';
    };
  };
}
