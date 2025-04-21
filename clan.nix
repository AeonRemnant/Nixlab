{ self, nixpkgs, clan, hostDefinitions, nixosConfigurations, ... }:

let
  mkClanNode = hostName: hostArgs: {
    target = "root@${hostArgs.ip or hostName}";

    config = nixosConfigurations."${hostName}";

    tags = hostArgs.tags or [];
  };
in
{
  # === Node Definitions ===
  nodes = nixpkgs.lib.mapAttrs mkClanNode hostDefinitions;

  settings = {
    parallel = 10;
  };
}