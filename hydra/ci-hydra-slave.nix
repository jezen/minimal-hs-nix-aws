{ config, lib, ... }:
{
  users.extraUsers.root.openssh.authorizedKeys.keys = lib.singleton ''
    command="nix-store --serve --write" ${builtins.readFile ../secret_key}
  '';
}
