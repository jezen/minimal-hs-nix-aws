{
  network.description = "Hydra VirtualBox";

  hydra =
  { config, pkgs, lib, ... }:
  {
    imports = [
      ./ci-hydra-master.nix
    ];

    deployment.targetEnv = "virtualbox";
    deployment.virtualbox.memorySize = 1024;
    deployment.virtualbox.vcpu = 1;
    deployment.virtualbox.headless = true;

    # Use binary caches to speedup builds
    services.hydra.useSubstitutes = true;

    systemd.services.hydra-create-user = {
      description = "Create Admin User for Hydra";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "hydra";
      };

      enable = false;

      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-init.service" ];
      after    = [ "hydra-init.service" ];
      path     = [ pkgs.nix ];
      script = ''
        sleep 10
        if [ ! -e ~hydra/.admin-created ]; then
          # create admin user
          /run/current-system/sw/bin/hydra-create-user admin --full-name 'Administrator' --email-address 'root@localhost' --password MySecretPassword --role admin --role hydra
          touch ~hydra/.admin-created
        fi
      '';
    };

    nix.buildMachines = [
      { hostName = "slave1";
        maxJobs = 1;
        speedFactor = 1;
        sshKey = "${../secret_key}";
        sshUser = "root";
        system = "x86_64-linux";
      }
    ];

  };

  slave1 =
  { config, pkgs, ... }:
  {
    imports = [ ./ci-hydra-slave.nix ];

    deployment.targetEnv = "virtualbox";
    deployment.virtualbox.memorySize = 1024;
    deployment.virtualbox.vcpu = 1;
    deployment.virtualbox.headless = true;
  };
}
