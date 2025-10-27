{
  makeServiceEntryPoint =
    { inputs, system, ... }@specialArgs:
    { modules }:
    {
      inherit system specialArgs;

      config = {
        imports = modules;
      };

      nixosSystem = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs modules;
      };
    };
}
