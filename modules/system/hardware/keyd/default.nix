{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.keyd.enable = true;

  services.keyd.keyboards.default = {
    ids = [ "*" ];
    settings.main = {
      # Emit `Escape` when clicked, and `Control` when held.
      capslock = "overload(control, esc)";
      # Emit `Caps Lock`.
      esc = "capslock";
    };
  };

  # Makes sure that when you type the make palm rejection work with keyd.
  # See <https://github.com/rvaiya/keyd/issues/723>.
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';

}
