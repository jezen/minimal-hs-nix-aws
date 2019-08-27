{ config, pkgs, lib, ... }:

let
  keys = import ./ci-keys.nix;
in {
  networking.firewall.allowedTCPPorts =
    [ config.services.hydra.port ];

  users.extraUsers.root.openssh.authorizedKeys.keys =
    [ keys."sigrlami" keys."sigrlami9" ];

  services.hydra.enable = true;
  services.hydra.hydraURL = "localhost:${toString config.services.hydra.port}";
  services.hydra.notificationSender = "admin@localhost";
  services.hydra.useSubstitutes = true;

  # serve nix-cache
  services.nix-serve = {
    enable = true;
    secretKeyFile = "/etc/nix/hydra.example.org-1/nix-serve";
  };

  systemd.services.hydra-manual-setup = {
    description = "Hydra manual setup";
    serviceConfig.Type = "oneshot";
    serviceConfig.RemainAfterExit = true;
    wantedBy = [ "multi-user.target" ];
    requires = [ "hydra-init.service" ];
    after = [ "hydra-init.service" ];
    path = [ pkgs.nix ];
    script = ''
      if [ ! -e ~hydra/.setup-is-complete ]; then
        # create admin user
        # /run/current-system/sw/bin/hydra-create-user alice --full-name 'Alice Q. User' --email-address 'alice@example.org' --password foobar --role admin
        # generate binary cache keys
        mkdir -m 0755 -p /etc/nix/hydra.example.org-1
        nix-store --generate-binary-cache-key hydra.example.org-1 /etc/nix/hydra.example.org-1/nix-serve /etc/nix/hydra.example.org-1/nix-serve.pub
        chown -R nix-serve:hydra /etc/nix/hydra.example.org-1
        chmod 0440 /etc/nix/hydra.example.org-1/nix-serve
        chmod 0444 /etc/nix/hydra.example.org-1/nix-serve.pub
        touch ~hydra/.setup-is-complete
      fi
    '';
  };

  nix = {
    distributedBuilds = true;
    extraOptions = ''
      auto-optimise-store = true
      allowed-uris = http:// https://
    '';
    # hydra-queue-runner --status reports runnables with 'feature'
    # suffix, i.e "x86_64-linux:local". Add localhost as a build
    # machine for such kind of runnables.
    buildMachines = [
      # build _feature_ as well as ordinary non-tagged runnables
      {
        hostName = "localhost";
        systems = [ "x86_64-linux" "i686-linux" ];
        maxJobs = 1;
        supportedFeatures = [ "kvm" "local" ];
      }
      # build only _feature_ tagged runnables
      {
        hostName = "localhost";
        systems = [ "x86_64-linux" "i686-linux" ];
        maxJobs = lib.max 1 (config.nix.maxJobs - 1);
        supportedFeatures = [ "kvm" ];
        # should prevent building runnables without 'feature' suffix
        mandatoryFeatures = [ "local" ];
      }
    ];
    # Enable automatic GC
    gc = {
      automatic = true;
      dates = "03,09,15,21:15";
      options = ''--max-freed "$((128 * 1024**3 - 1024 * $(df -P -k /nix/store | tail -n 1 | ${pkgs.gawk}/bin/awk '{ print $4 }')))"'';
    };
  };

  # Randomize GC start times do we don't block all build machines at
  # the same time.
  systemd.timers.nix-gc.timerConfig.RandomizedDelaySec = "1800";

  nixpkgs.config.allowUnfree = true;

}
