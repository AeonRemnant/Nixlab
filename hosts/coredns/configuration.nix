{ config, pkgs, lib, self, hostArgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./dns.nix
  ];

  networking.hostName = "coredns.lab";

  networking.interfaces.eth0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = hostArgs.ip;
      prefixLength = hostArgs.prefix;
    }];
  };

  networking.defaultGateway = hostArgs.gateway;
  networking.nameservers = hostArgs.nameservers;

  # Firewall rules for DNS
  networking.firewall.allowedUDPPorts = [ 53 ];
  networking.firewall.allowedTCPPorts = [ 53 ];

  services.comin = {
    enable = true;
    repositoryUrl = "https://github.com:aeonremnant/nixlab.git";
    flakeUri = ".#coredns";
    schedule = "*:0/01";
  };

  # System state version
  system.stateVersion = "unstable";
}