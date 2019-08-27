# Hydra Setup

Nixops expressions to deploy Hydra build system to Virtualbox and Amazon Web Services (AWS). Desribed in a form of master-slave configuration. Additionally, Hydra machine serves a Nix binary cache at `5000` port with the results of
the builds. To add extra binary cache to Nix you need to use specialize config st `/etc/nix/nix.conf`

```
binary-caches = http://hydra-machine:5000/
trusted-binary-caches = http://hydra-machine:5000/
binary-cache-public-keys = hydra.example.org-1:E0fClLowP/HkAxDC8syrbuklhITqXxEbHM6AsfICQQ0=
```

Hydra is CI system and can be installed with following commands

```bash
nix-channel --add http://hydra.nixos.org/jobset/hydra/master/channel/latest
nix-channel --update
nix-env -i hydra
```

## Deployment
### Local

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

Check ip address with `nixops info -d vydra`, and find correct one
```bash
+--------+-----------------+------------+----------------------------------------------------+----------------+
| Name   |      Status     | Type       | Resource Id                                        | IP address     |
+--------+-----------------+------------+----------------------------------------------------+----------------+
| hydra  | Up / Up-to-date | virtualbox | nixops-a2864970-c878-11e9-b626-f8cab8605876-hydra  | 192.168.56.103 |
| slave1 | Up / Up-to-date | virtualbox | nixops-a2864970-c878-11e9-b626-f8cab8605876-slave1 | 192.168.56.102 |
+--------+-----------------+------------+----------------------------------------------------+----------------+
```

navigate from browser to master/hydra machine by attaching port 3000.

### AWS

you need to use separate `ci-hydra.nix` file for deployment, with configuration for Hydra.

To setup build for every GitHub PR on a deployed Hydra instance we need following steps

```bash
$ nixops create ci-hydra-aws.nix ci-services.nix jobsets.nix -d aydra
$ nixops deploy -d aydrax
```
that will start Hydra CI master-slave configuration on AWS.

## Configuration

Hydra is based around concept of `jobsets`. You can create one from web-interface or reuse one provide
