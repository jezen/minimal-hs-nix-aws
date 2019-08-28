let
  ## -- Global system options ---------------------------------------
  profile     = "default";                 # https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  region      = "us-west-2";               # https://docs.aws.amazon.com/general/latest/gr/rande.html
  accessKeyId = "AKIAYQLZVKLZAOPBIEHJ";
  awsEC2type  = "t2.micro";                # https://aws.amazon.com/ec2/instance-types/
  privateKey  = "../nix.pem";              # /path/to/your-key-name.pem

in {
  network.description = "hydra-aws";
  hydra-master = { resources, ... }: {
    imports = [
      ./ci-hydra-master.nix
    ];

    deployment.targetEnv          = "ec2";
    deployment.ec2.accessKeyId    = accessKeyId;
    deployment.ec2.region         = region;
    deployment.ec2.instanceType   = "t2.small";
    deployment.ec2.keyPair        = "nix";
    deployment.ec2.privateKey     = privateKey;
    deployment.ec2.securityGroups = [ "default" "full-access" ];
    nixpkgs.localSystem.system    = "x86_64-linux";

    services.nginx = {
        enable     = true;
        httpConfig = ''
          server {
            listen 80;
            server_name _;

            location / {
              proxy_pass http://127.0.0.1:3000;
            }
          }
        '';
      };

  };

  hydra-slave = { resources, ... }: {
    imports = [
      ./ci-hydra-slave.nix
    ];

    deployment.targetEnv          = "ec2";
    deployment.ec2.accessKeyId    = accessKeyId;
    deployment.ec2.region         = region;
    deployment.ec2.instanceType   = awsEC2type;
    deployment.ec2.keyPair        = "nix";
    deployment.ec2.privateKey     = privateKey;
    deployment.ec2.securityGroups = [ "default" "full-access" ];
    nixpkgs.localSystem.system    = "x86_64-linux";
  };

}
