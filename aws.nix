let
  ## -- Global system options ---------------------------------------
  profile     = "default";                 # https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html
  region      = "eu-central-1";            # https://docs.aws.amazon.com/general/latest/gr/rande.html
  accessKeyId = "AKIA5UA2KBIJSFJQYMPQ";
  awsEC2type  = "t3.nano";                 # https://aws.amazon.com/ec2/instance-types/

in {

  production = { resources, ... }: {
    deployment.targetEnv        = "ec2";
    deployment.ec2.accessKeyId  = accessKeyId;
    deployment.ec2.region       = region;
    deployment.ec2.instanceType = awsEC2type;
    deployment.ec2.keyPair      = resources.ec2KeyPairs.minimal-keys;
    nixpkgs.localSystem.system  = "x86_64-linux";
  };

  resources.ec2KeyPairs.minimal-keys =
    { inherit region accessKeyId; };

}
