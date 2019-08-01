let
  ## -- Global system options ---------------------------------------
  awsProfile     = "default";                 # https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  awsRegion      = "eu-central-1";            # https://docs.aws.amazon.com/general/latest/gr/rande.html
  awsAccessKeyId = "AKIA5UA2KBIJSFJQYMPQ";
  awsEC2type     = "t3.nano";                 # https://aws.amazon.com/ec2/instance-types/

in {

  production = { resources, ... }: {
    deployment.targetEnv        = "ec2";
    deployment.ec2.accessKeyId  = awsAccessKeyId;
    deployment.ec2.region       = awsRegion;
    deployment.ec2.instanceType = awsEC2type;
    deployment.ec2.keyPair      = resources.ec2KeyPairs.minimal-keys;
    nixpkgs.localSystem.system  = "x86_64-linux";
  };

  resources.ec2KeyPairs.minimal-keys =
    { inherit awsRegion awsAccessKeyId; };

}
