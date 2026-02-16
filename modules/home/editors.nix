{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.home.editors = {
    enable = mkEnableOption "editor configuration";

    enableVscode = mkOption {
      type = types.bool;
      default = true;
      description = "Enable VSCode";
    };

    enableNeovim = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Neovim";
    };
  };

  config = mkIf config.modules.home.editors.enable {
    programs.vscode = mkIf config.modules.home.editors.enableVscode {
      enable = true;
    };

    programs.neovim = mkIf config.modules.home.editors.enableNeovim {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    # Common editor tools
    home.packages = with pkgs; [
      # LSP servers
      nil # Nix LSP
      nodePackages.bash-language-server

      # Formatters
      nixpkgs-fmt
      nodePackages.prettier
    ];
  };
}
