{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.users = {
    enable = mkEnableOption "user management";

    mainUser = mkOption {
      type = types.str;
      description = "Main user name";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [
        "wheel"
        "networkmanager"
      ];
      description = "Extra groups for main user";
    };
  };

  config = mkIf config.modules.users.enable {
    users.users.${config.modules.users.mainUser} = {
      isNormalUser = true;
      extraGroups = config.modules.users.extraGroups;
      shell = pkgs.zsh;
    };

    programs.zsh.enable = true;
  };
}
