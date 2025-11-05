{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.firewall.allowedTCPPorts = [ 8799 ];

  services.jupyter = {
    enable = true;

    ip = "0.0.0.0";
    port = 8799;
    password = "sha1:61c57e3b6c75:0260347a717616a527eeabee56e60471b1cf418d";
    command = "jupyter lab";

    kernels."python3-data-science" =
      let
        env = pkgs.python3.withPackages (
          p: with p; [
            ipympl
            ipython
            matplotlib
            mpmath
            numpy
            openpyxl
            pandas
            scikit-learn
            scipy
            statsmodels
            sympy
            typing-extensions
          ]
        );
      in
      {
        language = "python";
        displayName = "Python 3 for Data Science";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
  };
}
