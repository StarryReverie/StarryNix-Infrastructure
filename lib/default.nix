{
  makeNodeEntryPoint =
    nixpkgsLib:
    { system, ... }@specialArgs:
    { modules }:
    {
      inherit system specialArgs;

      config = {
        imports = modules;
      };

      nixosSystem = nixpkgsLib.nixosSystem {
        inherit system specialArgs modules;
      };
    };
}
