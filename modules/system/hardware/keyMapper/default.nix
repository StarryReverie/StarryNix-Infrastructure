{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.keyMapper;
in
{
  config = lib.mkIf customCfg.enable {
    services.keyd.enable = true;

    services.keyd.keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        # Emit `Escape` when clicked, and `Control` when held.
        capslock = "overload(control, esc)";
        # Emit `Caps Lock`.
        esc = "capslock";
        # Emit `Alt` when held, otherwise as-is.
        mouse1 = "overload(alt, mouse1)";
        # Emit `Super`/`Meta` when held, otherwise as-is.
        mouse2 = "overload(meta, mouse2)";
      };
    };

    # Makes sure that when you type to make palm rejection work with keyd.
    # See <https://github.com/rvaiya/keyd/issues/723>.
    environment.etc."libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
