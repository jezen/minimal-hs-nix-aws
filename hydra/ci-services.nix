{
  network.description = "hydra";

  production =
    { config, pkgs, ... }: let
      nixpkgs = import ./nixpkgs.nix;
      myPkgs  = import nixpkgs { localSystem.system = "x86_64-linux"; };

      hydra = pkgs.haskell.lib.overrideCabal (import ./default.nix { pkgs = myPkgs; }) (drv: {
        doCheck = false;
        doHaddock = false;
        enableLibraryProfiling = false;
        enableSeparateDataOutput = false;
        enableSharedExecutables = false;
        isLibrary = false;
        postFixup = "rm -rf $out/lib $out/nix-support $out/share/doc";
        testHaskellDepends = [];
      });
    in
    { networking.hostName = "hydra";

      networking.firewall = {
        allowedTCPPorts = [ 22 80 443];
        allowedUDPPorts = [ 25826 ];
      };

      environment.systemPackages = [ hydra ];

      services.nginx = {

        enable = true;

        httpConfig = ''

          server {
            listen 80;
            server_name _;

            location / {
              proxy_pass http://127.0.0.1:3000;
            }
          }

        '';

      };

      services.timesyncd.enable = true;

      services.fail2ban = {
        enable = true;

        jails.http-get-dos = ''
          action   = iptables-multiport
          backend  = auto
          bantime  = 600
          enabled  = true
          filter   = http-get-dos
          findtime = 3600
          logpath  = /var/spool/nginx/logs/access.log
          maxretry = 50
          port     = http,https
        '';
      };

    };
}
