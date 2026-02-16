{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.networking = {
    enable = mkEnableOption "networking configuration";

    hostName = mkOption {
      type = types.str;
      description = "Hostname for this machine";
    };

    enableNetworkManager = mkOption {
      type = types.bool;
      default = true;
      description = "Enable NetworkManager";
    };

    enableFirewall = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firewall";
    };
  };

  config = mkIf config.modules.networking.enable {
    networking = {
      hostName = config.modules.networking.hostName;
      networkmanager.enable = config.modules.networking.enableNetworkManager;

      firewall = mkIf config.modules.networking.enableFirewall {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };
  };
}
