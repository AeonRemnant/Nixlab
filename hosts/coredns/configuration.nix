{ config, pkgs, lib, self, hostArgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./dns.nix
  ];

  boot.loader.grub.devices = "/dev/sda";
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;

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