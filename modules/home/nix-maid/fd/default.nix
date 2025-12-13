{
  config,
  lib,
  pkgs,
  constants,
  ...
}:
{
  users.users.${constants.username}.maid = {
    packages = with pkgs; [ fd ];

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
}
