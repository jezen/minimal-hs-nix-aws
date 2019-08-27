# Hydra Setup

**TODO: update how to use master-slave setup**

Hydra is CI system and can be installed locally like this:
```bash
nix-channel --add http://hydra.nixos.org/jobset/hydra/master/channel/latest
nix-channel --update
nix-env -i hydra
```

you need to use separate `ci-hydra.nix` file for deployment, with configuration for Hydra.

To setup build for every GitHub PR on a deployed Hydra instance we need following steps

```bash
$ nixops create ci-aws.nix ci-services.nix ci-hydra.nix jobsets.nix -d hydra
$ nixops deploy -d hydra
```

that will start Hydra CI server on AWS.

## Local run

We can run Hydra locally inside VirtualBox

Generate access key in a repository root:

```
$ ssh-keygen -t ed25519 -C "provisioner@hydra" -N "" -f secret_key
```

Default configuration contains 2 VMs, Hydra master with a singe worker machine:

```bash
$ nixops create -d vydra ci-hydra-vbox.nix
$ nixops deploy -d vydra
```

Note that `ci-hydra-vbox.nix` already have connection to master and slave through imports.
