{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = lib.pipe (inputs.import-tree.withLib lib) [
    (it: it.addPath ./system)
    (it: it.addPath ./users)
    (it: it.filterNot (lib.hasInfix "starrynix-infrastructure"))
    (it: it.files)
  ];
}
