{
  network.description = "minimal";

  production =
    { config, pkgs, ... }: let
      nixpkgs = import ./nixpkgs.nix;
      myPkgs  = import nixpkgs { localSystem.system = "x86_64-linux"; };

      minimal = pkgs.haskell.lib.overrideCabal (import ./default.nix { pkgs = myPkgs; }) (drv: {
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
    { networking.hostName = "minimal";

      networking.firewall = {
        allowedTCPPorts = [ 22 80 ];
        allowedUDPPorts = [ 25826 ];
      };

      environment.systemPackages = [ minimal ];

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

      systemd.services.minimal = {
        description = "Minimal Webserver";
        requires = [];
        wantedBy = [ "multi-user.target" "nginx.service" ];
        after = [ "network.target" "local-fs.target" ];

        serviceConfig = {
          ExecStart = "${minimal}/bin/minimal";
        };
      };
    };
}
