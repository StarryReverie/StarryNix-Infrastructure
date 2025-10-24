{
  makeServiceEntryPoint =
    { inputs, system, ... }@specialArgs:
    { modules }:
    {
      inherit system specialArgs;

      config = {
        imports = modules;
      };
    };
}
