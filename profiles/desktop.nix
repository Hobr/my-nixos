{ config, ... }:

{
  # System modules
  modules.networking.enable = true;
  modules.users.enable = true;
  modules.desktop.enable = true;

  # Home manager modules
  home-manager.users.${config.modules.users.mainUser} = {
    modules.home.shell.enable = true;
    modules.home.git.enable = true;
    modules.home.editors.enable = true;
    modules.home.development.enable = true;
  };

  # System packages
  environment.systemPackages = [ ];
}
