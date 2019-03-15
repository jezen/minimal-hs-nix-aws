let
  region = "eu-central-1";
  accessKeyId = "your-access-key-id-here";

in {

  production = { resources, ... }: {
    deployment.targetEnv = "ec2";
    deployment.ec2.accessKeyId = accessKeyId;
    deployment.ec2.region = region;
    deployment.ec2.instanceType = "t2.small";
    deployment.ec2.keyPair = resources.ec2KeyPairs.minimal-keys;
    nixpkgs.localSystem.system = "x86_64-linux";
  };

  resources.ec2KeyPairs.minimal-keys = { inherit region accessKeyId; };
}
