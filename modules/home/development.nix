{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.home.development = {
    enable = mkEnableOption "development tools";

    languages = mkOption {
      type = types.listOf (
        types.enum [
          "nix"
          "python"
          "nodejs"
          "rust"
          "go"
        ]
      );
      default = [ "nix" ];
      description = "Programming languages to support";
    };
  };

  config = mkIf config.modules.home.development.enable {
    home.packages =
      with pkgs;
      [
        git
        gh
        direnv
      ]
      ++ optionals (elem "python" config.modules.home.development.languages) [
        python3
        poetry
      ]
      ++ optionals (elem "nodejs" config.modules.home.development.languages) [
        nodejs
        nodePackages.pnpm
      ]
      ++ optionals (elem "rust" config.modules.home.development.languages) [
        rustc
        cargo
      ]
      ++ optionals (elem "go" config.modules.home.development.languages) [ go ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
