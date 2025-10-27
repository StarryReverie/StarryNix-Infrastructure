{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.fd.enable = true;

  programs.fd.ignores = [
    "node_modules/**"
    "dist/**"
    "{,_}build/**"
    "target/**"
    "{,.}venv/**"
    "__pycache__/**"
    "vendor/**"
    ".gradle/**"
  ];
}
