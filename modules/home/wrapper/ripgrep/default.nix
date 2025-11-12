{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.ripgrep.basePackage = pkgs.ripgrep;

  wrappers.ripgrep.prependFlags = [
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
