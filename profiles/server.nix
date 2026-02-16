{ config, pkgs, ... }:

{
  # System modules
  modules.networking.enable = true;
  modules.users.enable = true;
  modules.desktop.enable = false;

  # Minimal system packages for servers
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    htop
  ];

  # Server specific services
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };
}
