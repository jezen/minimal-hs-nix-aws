{ config, pkgs, resources, ... }:

with builtins;

{
  ## -- Global networking/system options ---------------------------------------
  imports = [ ../hydra/hydra-module.nix ];

  nixpkgs.config.allowUnfree = true;

  networking.firewall.enable          = true;
  networking.firewall.rejectPackets   = false;
  networking.firewall.allowPing       = false;
  networking.firewall.allowedTCPPorts =
    [ 22 80 443   # SSH, HTTP(S)
      25565       # Minecraft server
      21025       # Starbound server
      64738       # Mumble
    ];
  networking.firewall.allowedUDPPorts =
    [ 21025       # Starbound server
      64738       # Mumble
    ];
  networking.firewall.allowedUDPPortRanges =
    [ { from = 60000; to = 61000; } ]; # Mosh port ranges


  ## -- Hydra ------------------------------------------------------------------

  services.hydra = {
    enable                   = true;
    package                  =
      (import ../hydra/release.nix {}).build.x86_64-linux;
    hydraURL                 = "https://hydra.example.org";
    listenHost               = "127.0.0.1";
    port                     = 3000;
    minimumDiskFree          = 5; # in GB
    minimumDiskFreeEvaluator = 2;
    notificationSender       = "hydra@example.org";
    logo                     = ../resources/img/hydra-logo.png;
    debugServer              = false;
  };
}