{
description = "NixLab, a configuration set for my homelab.";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
};

outputs = { self, nixpkgs }:
  let

    commonModules = [
      ./modules/common/core.nix
    ];

    baseArgs = {
      prefix = 21;
      gateway = "10.0.0.1";
      nameservers = [ "10.1.1.88" "1.1.1.1" ];
      system = "x86_64-linux";
      };

    mkTemplate = { name, system, finalHostArgs }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit self;
          hostArgs = finalHostArgs;
        };
        modules = commonModules ++ [ ./hosts/${name}/configuration.nix ];
      };
    
    hostDefinitions = import ./hosts.nix;

  in
  {
    nixosConfigurations = nixpkgs.lib.mapAttrs
        (hostName: hostSpecificArgs:
          let
            finalArgs = baseArgs // hostSpecificArgs;
          in
            mkTemplate {
              name = hostName;
              system = finalArgs.system;
              finalHostArgs = finalArgs;
            }
        )
        hostDefinitions;
  };
}
