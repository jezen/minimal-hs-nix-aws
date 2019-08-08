{
  hydra = { config, lib, pkgs, resources, ... }:
  { networking.hostName = "hydra";
    networking.firewall.allowedTCPPorts =
      [ ## config.services.hydra.port 25
        22   #
        25
        8080 # Hydra web UI
        5000 # nix-serve daemon (Nix cache)
      ];

    services.hydra = {
      enable = true;
      minimumDiskFree = 10; # GiB
      minimumDiskFreeEvaluator = 10; # GiB
      hydraURL = "http://localhost:8080";
      notificationSender = "hydra@localhost";
      services.hydra.port = 8080;
      services.hydra.logo = ./custom-logo.png;
      buildMachinesFiles = [];
      useSubstitutes = true;
    };

    ## add private repo handling
    programs.ssh.knownHosts =
      [{ hostNames = [ "github.com" ];
         publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
       }
      ];

    # nix-serve - Nix cache daemon
    services.nix-serve.enable = true;

    # nix =
    # { useSandbox   = true;
    #   buildCores   =  0;
    #   nrBuildUsers = 32;

    #   buildMachines = [
    #     { hostName = "localhost";
    #       system   = "x86_64-linux";
    #       supportedFeatures =
    #         [ "kvm"
    #           "nixos-test"
    #           "big-parallel"
    #           "benchmark"
    #         ];
    #       maxJobs = "12";
    #     }
    #   ];
    # };
  };
}
