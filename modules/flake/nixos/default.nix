{
  config,
  inputs,
  self,
  ...
}:
{
  imports = [
    ./colmena.nix
    ./hosts.nix
    ./nodes.nix
    ./secret-registry.nix
  ];
}
