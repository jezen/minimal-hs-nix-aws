{
  hydra = { config, lib, pkgs, resources, ... }:
  { networking.hostName = "hydra";
    networking.firewall.allowedTCPPorts =
      [ ## config.services.hydra.port 25
        22 80 443
      ];

    services.hydra =
    { enable = true;
      minimumDiskFree = 10; # GiB
      minimumDiskFreeEvaluator = 10; # GiB
      hydraURL = "hydra.localhost.com";
      notificationSender = "admin@domain.com";
    };
    programs.ssh.knownHosts =
      [{ hostNames = [ "github.com" ];
         publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
       }
      ];

    nix =
    { useSandbox = true;
      buildCores =  0;
      nrBuildUsers = 32;

      buildMachines = [
        { hostName = "localhost";
          system = "x86_64-linux";
          supportedFeatures =
            [ "kvm"
              "nixos-test"
              "big-parallel"
              "benchmark"
            ];
          maxJobs = "12";
        }
      ];
    };
  };
}
