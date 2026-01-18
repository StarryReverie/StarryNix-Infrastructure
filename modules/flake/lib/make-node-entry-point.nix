{
  config,
  inputs,
  self,
  ...
}:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
in
{
  flake.lib = {
    makeNodeEntryPoint =
      { modules, specialArgs }:
      {
        inherit specialArgs;

        config = {
          imports = modules;
        };

        nixosSystem = nixpkgs-lib.nixosSystem {
          inherit specialArgs modules;
        };
      };
  };
}
