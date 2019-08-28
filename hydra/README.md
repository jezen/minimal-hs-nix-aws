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

We can run Hydra locally inside VirtualBox, functionality provided in `ci-hydra-vbox.nix` but you need to do aditional step to configure proper access.

1. Generate access key in a repository root:

```
$ ssh-keygen -t ed25519 -C "provisioner@hydra" -N "" -f secret_key
```

2. Add this key to `ci-keys.nix` with desired synonym.

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

You need to use separate `ci-aws-hydra.nix` file for deployment wich builds everything required for the basic Hydra deployment with following commands

```bash
$ nixops create -d aydra ci-hydra-aws.nix
$ nixops deploy -d aydra
```
that will start Hydra CI master-slave configuration on AWS. After that you can create specific jobsets that define build rules.

## Configuration

Hydra is based around concept of `jobsets`. You can create one from web-interface or reuse one provide by this repository in `jobsets.nix`. This particular jobset oriented towards PR-based approach that will build particular branch on PR submitted to the repository. In order to get access to private repo, you need to supply ssh dev key to the hydra instance inside `ci-hydra-master.nix`. You can attach already defined jobsets and deploy with following commands

```bash
$ nixops create -d aydra ci-hydra-aws.nix jobsets.nix
$ nixops deploy -d aydra
```
