{ config, pkgs, lib, self, hostArgs, modulesPath, ... }:

{

  disko.devices = {
    disk = {
      primary = {
        device = "/dev/vda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = [
            {
              name = "boot";
              type = "EF00";
              size = "2048M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            }
            {
              name = "root";
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                mountpoint = "/";
              };
            }
          ];
        };
      };
    };
  };
}