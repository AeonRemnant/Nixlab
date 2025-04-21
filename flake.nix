{
description = "NixLab, a configuration set for my homelab.";

inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  clan = {
    url = "github:pdtpartners/clan/main";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

outputs = { self, nixpkgs, clan }:
  let

    commonModules = [
      ./modules/common/core.nix
      ./modules/common/nushell.nix
      ./modules/common/security.nix
    ];

    baseArgs = {
      prefix = 21;
      gateway = "10.0.0.1";
      nameservers = [ "10.1.1.99" "1.1.1.1" ];
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
  in
  {
    inherit nixosConfigurations;
    clanConfigurations.default = import ./clan.nix {
      inherit self nixpkgs clan;
      inherit hostDefinitions nixosConfigurations;
    };
  };
}
