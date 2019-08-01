# Minimal Haskell & NixOps Example

This is a working Haskell application with one route (`/`), which returns an
empty JSON object and a 200 status.

The Nix configuration is set up to allow AWS EC2 provisioning and deployment.

## Prerequisites

1. You need to instal Nix
2. You need to install NixOps
3. You must add specific changes to `aws.nix`
```yaml
let
  region = "your-region";
  accessKeyId = "your-access-key-id-here";
```

where
- `region`     , variable that defined AWS region from list of availables, like `us-east-1`, `eu-central-1`, etc.
- `accessKeyId`, AWS generate access key.
- In order to operate properly you need to have a file named `~/.ec2-keys` in your home directory, with contents in a following format:
```
<Access key ID 1> <Secret access key 1>
<Access key ID 2> <Secret access key 2>
AKIAJ700000000000000 tBoCp111n111UE3o33333333333SiglhhhhhhQGs
```
that can be obtained from AWS IAM service.
Or manually set `$EC2_SECRET_KEY` and `$AWS_SECRET_ACCESS_KEY` variables.

## AWS profiles setup
If you're working with multiple AWS organizations you can setup keys configuration with already available `.aws/credentials`. It's a better way if you don't want to expose access key id or create duplicate entity like `.ec2-keys`. Setup available at `aws-ext.nix` and you should replace it for every command where `aws.nix` used.

Just write name of the profile you want to deploy with
```

```


## Configure & Deploy

Build package first, ensure everything is correct
```bash
$ nix-build default.nix
```

Next, You can create a new deployment with following command:
```bash
$ nixops create services.nix aws.nix -d minimal
```

And then you can deploy it:
```bash
$ nixops deploy -d minimal
```

Any time you change the code and wish to redeploy, you must first modify the
NixOps deployment with the following command:
```bash
$ nixops modify -d minimal services.nix aws.nix
```

Once the application is deployed, you can access it by its IP address.

### Comments

- Don't forget to modify the AWS security group so it allows HTTP access!
- I would like to see rate limiting with nginx, and a strategy for banning
scrapers and brute-force attempts, possibly with fail2ban.
- The Haskell application must be compiled on a Linux machine.

## Hydra Setup

Hydra is CI system and can be installed locally like this:
```bash
nix-channel --add http://hydra.nixos.org/jobset/hydra/master/channel/latest
nix-channel --update
nix-env -i hydra
```

you need to use separate `ci-hydra.nix` file for deployment, with configuration for Hydra.

To setup build for every GitHub PR on a deployed Hydra instance we need following steps

```bash
$ nixops create aws.nix hydra.nix -d ci-hydra
$ nixops deploy -d ci-hydra
```

that will start Hydra CI server
