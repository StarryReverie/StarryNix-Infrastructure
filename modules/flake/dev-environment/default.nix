{
  config,
  inputs,
  withSystem,
  ...
}:
{
  imports = [
    ./shell.nix
    ./formatter.nix
  ];
}
