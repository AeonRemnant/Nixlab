{ config, pkgs, lib, ... }:

let
  nushellConfigNuContent = ''
    $env.config = {
      show_banner: false
      # Add other desired default config settings
    }
  '';
  nushellEnvNuContent = ''
    $env.EDITOR = "hx"
    # Add other desired default environment settings
  '';

  defaultConfigNu = pkgs.writeText "default-config.nu" nushellConfigNuContent;
  defaultEnvNu = pkgs.writeText "default-env.nu" nushellEnvNuContent;
in
{
  environment.systemPackages = [ pkgs.nushell ];

  users.defaultUserShell = pkgs.nushell;
  users.users.root.shell = pkgs.nushell;

  system.activationScripts.setupRootNushellConfig = lib.stringAfter [ "users" ] ''
    echo "Setting up root Nushell config..."
    USER_HOME=/root
    CONFIG_DIR="$USER_HOME/.config/nushell"
    mkdir -p "$CONFIG_DIR"
    ln -sf "${defaultConfigNu}" "$CONFIG_DIR/config.nu"
    ln -sf "${defaultEnvNu}" "$CONFIG_DIR/env.nu"
    chown -R root:root "$USER_HOME/.config" || true
  '';
}