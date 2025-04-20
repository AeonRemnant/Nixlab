{ config, pkgs, lib, self, hostArgs, ... }:

{
  services.coredns = {
    enable = true;
    package = pkgs.coredns;
    config = ''
      # Default server block for all queries
      . {
          forward . ${builtins.concatStringsSep " " hostArgs.nameservers}

          # Cache forwarded results for 30 seconds
          cache 30

          # Log errors to journald
          errors
      }
    '';
  };
}