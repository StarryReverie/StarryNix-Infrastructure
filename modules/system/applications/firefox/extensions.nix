{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.firefox.policies.ExtensionSettings =
    let
      extension = name: uuid: {
        name = uuid;
        value = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${name}/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    in
    lib.attrsets.listToAttrs [
      (extension "auto-tab-discard" "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}")
      (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
      (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
      (extension "darkreader" "addon@darkreader.org")
      (extension "decentraleyes" "jid1-BoFifL9Vbdl2zQ@jetpack")
      (extension "i-dont-care-about-cookies" "jid1-KKzOGWgsW3Ao4Q@jetpack")
      (extension "keepassxc-browser" "keepassxc-browser@keepassxc.org")
      (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")
      (extension "scroll_anywhere" "juraj.masiar@gmail.com_ScrollAnywhere")
      (extension "skip-redirect" "skipredirect@sblask")
      (extension "smart-https-revived" "{b3e677f4-1150-4387-8629-da738260a48e}")
      (extension "tampermonkey" "firefox@tampermonkey.net")
      (extension "textarea-cache" "textarea-cache-lite@wildsky.cc")
      (extension "ublock-origin" "uBlock0@raymondhill.net")
    ];
}
