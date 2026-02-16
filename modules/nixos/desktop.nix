{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.desktop = {
    enable = mkEnableOption "desktop environment";

    type = mkOption {
      type = types.enum [
        "gnome"
        "kde"
        "hyprland"
      ];
      default = "gnome";
      description = "Desktop environment type";
    };

    enableWayland = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Wayland support";
    };
  };

  config = mkIf config.modules.desktop.enable {
    # X11/Wayland
    services.xserver = {
      enable = true;
      xkb.layout = "us";
    };

    # Desktop specific (使用新的 API)
    services.displayManager.gdm.enable = mkIf (config.modules.desktop.type == "gnome") true;
    services.desktopManager.gnome.enable = mkIf (config.modules.desktop.type == "gnome") true;

    services.displayManager.sddm.enable = mkIf (config.modules.desktop.type == "kde") true;
    services.desktopManager.plasma6.enable = mkIf (config.modules.desktop.type == "kde") true;

    programs.hyprland.enable = mkIf (config.modules.desktop.type == "hyprland") true;

    # Sound
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Fonts
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      font-awesome
    ];
  };
}
