{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.hardware.console;
in
{
  config = lib.mkIf customCfg.enable {
    console = {
      earlySetup = true;
      packages = [ pkgs.terminus_font ];
      font = "${pkgs.terminus_font}/share/consolefonts/ter-d24b.psf.gz";
    };
  };
}
