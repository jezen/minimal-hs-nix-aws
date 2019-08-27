let
  ## -- Global system options ---------------------------------------
  profile     = "default";                 # https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  region      = "us-west-2";               # https://docs.aws.amazon.com/general/latest/gr/rande.html
  accessKeyId = "AKIAYQLZVKLZAOPBIEHJ";
  awsEC2type  = "t2.micro";                # https://aws.amazon.com/ec2/instance-types/
  privateKey  = "../nix.pem";              # /path/to/your-key-name.pem

in {

  production = { resources, ... }: {
    deployment.targetEnv        = "ec2";
    deployment.ec2.accessKeyId  = accessKeyId;
    deployment.ec2.region       = region;
    deployment.ec2.instanceType = awsEC2type;
    deployment.ec2.keyPair      = "nix";
    deployment.ec2.privateKey   = privateKey;
    deployment.ec2.securityGroups = [ "default" "full-access" ];
    nixpkgs.localSystem.system  = "x86_64-linux";
  };


}
