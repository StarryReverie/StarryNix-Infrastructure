{
  config,
  lib,
  pkgs,
  ...
}:
{
  users.users.starryreverie.maid = {
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
