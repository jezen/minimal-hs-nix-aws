# Hydra Setup

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