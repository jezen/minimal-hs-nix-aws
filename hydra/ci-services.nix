{  network.description = "hydra";
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
    {
      networking.hostName = "hydra";
      networking.firewall = {
        allowedTCPPorts = [ 22 80 443];
        allowedUDPPorts = [ 25826 ];
      };


      environment.systemPackages = [ hydra ];

      # for remote access to the machine
      # services.ntp.enable                     = false;
      # services.openssh.enable                 = true;
      # services.openssh.permitRootLogin        = "yes";
      # services.openssh.allowSFTP              = false;
      # services.openssh.passwordAuthentication = false;
      # users = {
      #   mutableUsers = false;
      #   users.root.openssh.authorizedKeys.keyFiles = [ ~/.ssh/id_rsa.pub ];
      # };

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


    };
}
