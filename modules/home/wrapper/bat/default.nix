{
  config,
  lib,
  pkgs,
  ...
}:
{
  wrappers.bat.basePackage = pkgs.bat;

  wrappers.bat.prependFlags = [
    "--style=header,header-filesize,grid"
    "--theme=OneHalfDark"
  ];
}
