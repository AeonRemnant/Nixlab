{ config, pkgs, lib, self, hostArgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./dns.nix
    ./disko.nix
  ];

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 10; 
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  networking.hostName = "coredns";

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

  # System state version
  system.stateVersion = "25.05";
}