{ pkgs, ... }:

{
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_AU.UTF-8";
    
  environment.systemPackages = with pkgs; [
      
      # Shell
      ghostty
      nushell

      # Tools
      git
      curl
      wget
      helix
      fastfetch
      iotop
      ncdu
      htop
      unzip
      mtr
      dnsutils
      tcpdump

       # GitOps
      comin

      # System Security
      lynis
  ];

  services.openssh = {
      enable = true;
      settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
      };
  };
}