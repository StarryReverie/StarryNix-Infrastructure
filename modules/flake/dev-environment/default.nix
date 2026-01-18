{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./shell.nix
    ./formatter.nix
  ];
}
