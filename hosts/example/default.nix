{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../profiles/desktop.nix
  ];

  # 允许 unfree 软件
  nixpkgs.config.allowUnfree = true;

  # Host specific configuration
  modules.networking.hostName = "example";
  modules.users.mainUser = "user";
  modules.desktop.type = "gnome";

  # Home manager user configuration
  home-manager.users.${config.modules.users.mainUser} = {
    home.stateVersion = "24.11";

    # User specific home configuration
    modules.home.git = {
      userName = "Your Name";
      userEmail = "your.email@example.com";
    };

    modules.home.development.languages = [
      "nix"
      "python"
      "nodejs"
    ];
  };

  # Boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Time zone and locale
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  # System state version
  system.stateVersion = "24.11";
}
