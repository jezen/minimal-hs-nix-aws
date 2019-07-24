# Minimal Haskell & NixOps Example

This is a working Haskell application with one route (`/`), which returns an
empty JSON object and a 200 status.

The Nix configuration is set up to allow AWS EC2 provisioning and deployment.

## Prerequisites

1. You must change the following to your own credentials:

```yaml
let
  region = "your-region";
  accessKeyId = "your-access-key-id-here";
```

- use AWS defined variable for region, like `us-east-1`, `eu-central-1`, etc.
- use generated AWS access key. In order to operate properly you need to have a file named `~/.ec2-keys`
  in your home directory, with contents like the following `AKIAJ700000000000000 tBoCp111n111UE3o33333333333SiglhhhhhhQGs your-access-key-id-here`

2. You need to instal Nix
3. You need to install NixOps

## Configure & Deploy

You can create a new deployment with following command:

```bash
$ nixops create -d minimal services.nix aws.nix
```

And then you can deploy it:

```bash
$ nixops deploy -d minimal
```

Don't forget to modify the AWS security group so it allows HTTP access!

Once the application is deployed, you can access it by its IP address.

Any time you change the code and wish to redeploy, you must first modify the
NixOps deployment with the following command:

```bash
$ nixops modify -d minimal services.nix aws.nix
```

## Comments

I would like to see rate limiting with nginx, and a strategy for banning
scrapers and brute-force attempts, possibly with fail2ban.

n.b. The Haskell application must be compiled on a Linux machine.
