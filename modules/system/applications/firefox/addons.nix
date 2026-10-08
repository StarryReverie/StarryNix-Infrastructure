{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.applications.firefox;
in
{
  config = lib.mkIf customCfg.enable {
    programs.firefox.policies.ExtensionSettings =
      let
        addon = name: uuid: {
          name = uuid;
          value = {
            install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${name}/latest.xpi";
            installation_mode = "normal_installed";
          };
        };
      in
      lib.attrsets.listToAttrs [
        # Extensions
        (addon "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
        (addon "canvasblocker" "CanvasBlocker@kkapsner.de")
        (addon "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
        (addon "darkreader" "addon@darkreader.org")
        (addon "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
        (addon "i-dont-care-about-cookies" "jid1-KKzOGWgsW3Ao4Q@jetpack")
        (addon "keepassxc-browser" "keepassxc-browser@keepassxc.org")
        (addon "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
        (addon "scroll_anywhere" "juraj.masiar@gmail.com_ScrollAnywhere")
        (addon "skip-redirect" "skipredirect@sblask")
        (addon "smart-https-revived" "{b3e677f4-1150-4387-8629-da738260a48e}")
        (addon "tampermonkey" "firefox@tampermonkey.net")
        (addon "textarea-cache" "textarea-cache-lite@wildsky.cc")
        (addon "ublock-origin" "uBlock0@raymondhill.net")
        # Themes
        (addon "rose-pine-moon-modified" "{32aac792-0421-4e99-917a-c849311377ce}")
      ];
  };
}
