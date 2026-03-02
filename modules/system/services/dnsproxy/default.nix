{
  config,
  lib,
  pkgs,
  ...
}:
let
  customCfg = config.custom.system.services.dnsproxy;
in
{
  config = lib.mkIf customCfg.enable {
    networking.nameservers = [ "127.0.0.35:5353" ];

    services.dnsproxy.enable = true;

    services.dnsproxy.settings = {
      listen-addrs = [ "127.0.0.35" ];
      listen-ports = [ 5353 ];

      bootstrap = [
        "1.1.1.1:53"
        "8.8.8.8:53"
      ];

      upstream = [
        # a-and-a
        "sdns://AgcAAAAAAAAADTIxNy4xNjkuMjAuMjIADWRucy5hYS5uZXQudWsKL2Rucy1xdWVyeQ"
        # adguard-dns-doh
        "sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNCCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTQuMTQKL2Rucy1xdWVyeQ"
        "sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNSCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTUuMTUKL2Rucy1xdWVyeQ"
        # circl-doh
        "sdns://AgYAAAAAAAAADTE4NS4xOTQuOTQuNzEADGRucy5jaXJjbC5sdQovZG5zLXF1ZXJ5"
        # cleanbrowsing-security-doh
        "sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwoPn_N_AuYyy3OHAlwH5XkIo9Nxt8ldjN0DkN4jHtlDoSoCso0AXN1mJZ2xEYZeoXy7YLPI9UcGhjjZAqZL54Sv34IOaSTdvwPj_u_RiUGT7gQuBqadbySK2eIW2kKyiPLBAZEWNsZWFuYnJvd3Npbmcub3JnFC9kb2gvc2VjdXJpdHktZmlsdGVy"
        "sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OKD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6EqArKNAFzdZiWdsRGGXqF8u2CzyPVHBoY42QKmS-eEr9-CDmkk3b8D4_7v0YlBk-4ELgamnW8kitniFtpCsojywQGRFjbGVhbmJyb3dzaW5nLm9yZxQvZG9oL3NlY3VyaXR5LWZpbHRlcg"
        # cloudflare-security
        "sdns://AgMAAAAAAAAABzEuMC4wLjIABzEuMC4wLjIKL2Rucy1xdWVyeQ"
        # comss.one
        "sdns://AgMAAAAAAAAADjgzLjIyMC4xNjkuMTU1IOVh_sR8Wh3NwumyfOVEFrzdxzIG9bZ6Vl2nNfJprop5DWRucy5jb21zcy5vbmUKL2Rucy1xdWVyeQ"
        # controld-block-malware-ad
        "sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMg"
        # dns.digitale-gesellschaft.ch
        "sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDIgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5"
        "sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDMgkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5"
        # dns4eu-protective
        "sdns://AgMAAAAAAAAACjg2LjU0LjExLjEgkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkWcHJvdGVjdGl2ZS5qb2luZG5zNC5ldQovZG5zLXF1ZXJ5"
        # dnsforfamily-doh
        "sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyCdSDK7TI13IHsl3hdZJoLvw8pF9XncZkoO1fJI9ckzmBhkbnMtZG9oLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ"
        # dnsbunker
        "sdns://AgMAAAAAAAAADjE1Mi41My4yMDcuMTkxILTgqMmLCq5DtzgwN6zNEaHJZJcfa3T8vDcM0DD7Mo3dDWRuc2J1bmtlci5vcmcKL2Rucy1xdWVyeQ"
        # dnsforge.de
        "sdns://AgMAAAAAAAAADDE3Ni45LjkzLjE5OCCQeNIaVsDgiR2QYiG2mSMxvdFxcusPM92gfVxlxuFMOQtkbnNmb3JnZS5kZQovZG5zLXF1ZXJ5"
        # doh-crpyto-sx
        "sdns://AgcAAAAAAAAADjE3Mi42Ny4xMzQuMTU3AA1kb2guY3J5cHRvLnN4Ci9kbnMtcXVlcnk"
        # doh.ibksturm
        "sdns://AgcAAAAAAAAAAAAUaWJrc3R1cm0uc3lub2xvZ3kubWUKL2Rucy1xdWVyeQ"
        # doh.tiar.app-doh
        "sdns://AgMAAAAAAAAADjE3NC4xMzguMjkuMTc1ILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0DGRvaC50aWFyLmFwcAovZG5zLXF1ZXJ5"
        # doh.tiarap.org
        "sdns://AgMAAAAAAAAADDEwNC4yMS42NS42MAAOZG9oLnRpYXJhcC5vcmcKL2Rucy1xdWVyeQ"
        # fdn
        "sdns://AgcAAAAAAAAADDgwLjY3LjE2OS40MCCyXy82ln9zlPCZN4hbMz-qNW1xn-rPOMzp8DVQAPPhdApuczEuZmRuLmZyCi9kbnMtcXVlcnk"
        # jp.tiar.app-doh
        "sdns://AgcAAAAAAAAADTE3Mi4xMDQuOTMuODAgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQLanAudGlhci5hcHAKL2Rucy1xdWVyeQ"
        # mullvad-adblock-doh
        "sdns://AgMAAAAAAAAACzE5NC4yNDIuMi4zABdhZGJsb2NrLmRucy5tdWxsdmFkLm5ldAovZG5zLXF1ZXJ5"
        # nextdns
        "sdns://AgcAAAAAAAAACjQ1LjkwLjMwLjAgmjo09yfeubylEAPZzpw5-PJ92cUkKQHCurGkTmNaAhkWYW55Y2FzdC5kbnMubmV4dGRucy5pbwovZG5zLXF1ZXJ5"
        # njalla-doh
        "sdns://AgcAAAAAAAAADDk1LjIxNS4xOS41MyDWHZbr-z-hkJbiwALjYDv3_arvsicE2oZoBiu-hu1LkwtkbnMubmphbC5sYQovZG5zLXF1ZXJ5"
        # restena-doh-ipv4
        "sdns://AgcAAAAAAAAACzE1OC42NC4xLjI5IDDf1DoabxEd4ETIZd8xjTi-zEq1FHcQJ7CmCmYcUM5WEWRuc3B1Yi5yZXN0ZW5hLmx1Ci9kbnMtcXVlcnk"
        # rethinkdns-doh
        "sdns://AgYAAAAAAAAAACCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGRJtYXgucmV0aGlua2Rucy5jb20KL2Rucy1xdWVyeQ"
        # switch
        "sdns://AgMAAAAAAAAADTEzMC41OS4zMS4yNDggsBkgdEu7dsmrBT4B4Ht-BQ5HPSD3n3vqQ1-v5DydJC8NMTMwLjU5LjMxLjI0OAovZG5zLXF1ZXJ5"
        # uncensoreddns-ipv4
        "sdns://AgYAAAAAAAAADjkxLjIzOS4xMDAuMTAwIJB40hpWwOCJHZBiIbaZIzG90XFy6w8z3aB9XGXG4Uw5GWFueWNhc3QudW5jZW5zb3JlZGRucy5vcmcKL2Rucy1xdWVyeQ"
        # wikimedia
        "sdns://AgcAAAAAAAAADjE4NS43MS4xMzguMTM4ILJfLzaWf3OU8Jk3iFszP6o1bXGf6s84zOnwNVAA8-F0EXdpa2ltZWRpYS1kbnMub3JnCi9kbnMtcXVlcnk"

        # alidns-doh
        "sdns://AgAAAAAAAAAADjExMy4xNDIuODMuMTMyIJjj1eU2rylYzS9_FPcE70onbSXjPNZfLmX15PJyfBMwDjExMy4xNDIuODMuMTMyCi9kbnMtcXVlcnk"
      ];
    };
  };
}
