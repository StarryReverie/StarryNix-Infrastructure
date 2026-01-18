{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 8248 ];

  services.searx = {
    enable = true;

    settings = {
      server = {
        bind_address = "0.0.0.0";
        port = 8248;
        secret_key = "$SEARXNG_SECRET_KEY";
      };

      search = {
        autocomplete = "duckduckgo";
      };

      ui = {
        results_on_new_tab = true;
      };

      engines = lib.mapAttrsToList (name: value: { inherit name; } // value) {
        "bing".disabled = false;
        "nixos wiki".disabled = false;

        "hoogle".disabled = true;
        "pypi".disabled = true;
      };
    };

    environmentFile = config.age.secrets."searxng-secrets".path;
  };

  age.secrets."searxng-secrets" = {
    rekeyFile = ./secrets/searxng-secrets.age;
    owner = "searx";
  };
}
