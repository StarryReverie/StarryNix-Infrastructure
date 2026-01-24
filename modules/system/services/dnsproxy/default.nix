{
  config,
  lib,
  pkgs,
  ...
}:
{
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
      # adguard-dns-doh
      "sdns://AgMAAAAAAAAADDk0LjE0MC4xNC4xNCCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTQuMTQKL2Rucy1xdWVyeQ"
      "sdns://AgMAAAAAAAAADDk0LjE0MC4xNS4xNSCaOjT3J965vKUQA9nOnDn48n3ZxSQpAcK6saROY1oCGQw5NC4xNDAuMTUuMTUKL2Rucy1xdWVyeQ"
      # cleanbrowsing-security-doh
      "sdns://AgMAAAAAAAAADjE4NS4yMjguMTY4LjEwoPn_N_AuYyy3OHAlwH5XkIo9Nxt8ldjN0DkN4jHtlDoSoCso0AXN1mJZ2xEYZeoXy7YLPI9UcGhjjZAqZL54Sv34IOaSTdvwPj_u_RiUGT7gQuBqadbySK2eIW2kKyiPLBAZEWNsZWFuYnJvd3Npbmcub3JnFC9kb2gvc2VjdXJpdHktZmlsdGVy"
      "sdns://AgMAAAAAAAAADzE4NS4yMjguMTY4LjE2OKD5_zfwLmMstzhwJcB-V5CKPTcbfJXYzdA5DeIx7ZQ6EqArKNAFzdZiWdsRGGXqF8u2CzyPVHBoY42QKmS-eEr9-CDmkk3b8D4_7v0YlBk-4ELgamnW8kitniFtpCsojywQGRFjbGVhbmJyb3dzaW5nLm9yZxQvZG9oL3NlY3VyaXR5LWZpbHRlcg"
      # controld-block-malware-ad
      "sdns://AgMAAAAAAAAACjc2Ljc2LjIuMTEAFGZyZWVkbnMuY29udHJvbGQuY29tAy9wMg"
      # dns.digitale-gesellschaft.ch
      "sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDIgsl8vNpZ_c5TwmTeIWzM_qjVtcZ_qzzjM6fA1UADz4XQcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5"
      "sdns://AgcAAAAAAAAADTE4NS45NS4yMTguNDMgkHjSGlbA4IkdkGIhtpkjMb3RcXLrDzPdoH1cZcbhTDkcZG5zLmRpZ2l0YWxlLWdlc2VsbHNjaGFmdC5jaAovZG5zLXF1ZXJ5"
      # dnsforfamily-doh
      "sdns://AgMAAAAAAAAADzE2Ny4yMzUuMjM2LjEwNyCdSDK7TI13IHsl3hdZJoLvw8pF9XncZkoO1fJI9ckzmBhkbnMtZG9oLmRuc2ZvcmZhbWlseS5jb20KL2Rucy1xdWVyeQ"
    ];
  };
}
