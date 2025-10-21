{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.ripgrep.enable = true;

  programs.ripgrep.arguments = [
    "--smart-case"
    "--glob=!**/node_modules/**"
    "--glob=!**/dist/**"
    "--glob=!**/{,_}build/**"
    "--glob=!**/target/**"
    "--glob=!**/{,.}venv/**"
    "--glob=!**/__pycache__/**"
    "--glob=!**/vendor/**"
    "--glob=!**/pkg/**"
    "--glob=!**/bin/**"
    "--glob=!**/.gradle/**"
  ];
}
