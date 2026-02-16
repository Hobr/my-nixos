{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.home.shell = {
    enable = mkEnableOption "shell configuration";

    enableZsh = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Zsh configuration";
    };

    enableStarship = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Starship prompt";
    };
  };

  config = mkIf config.modules.home.shell.enable {
    programs.zsh = mkIf config.modules.home.shell.enableZsh {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -la";
        ".." = "cd ..";
        update = "sudo nixos-rebuild switch --flake .#";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };

    programs.starship = mkIf config.modules.home.shell.enableStarship {
      enable = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
      };
    };

    programs.bash.enable = true;
  };
}
