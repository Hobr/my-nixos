{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.modules.home.git = {
    enable = mkEnableOption "git configuration";

    userName = mkOption {
      type = types.str;
      description = "Git user name";
    };

    userEmail = mkOption {
      type = types.str;
      description = "Git user email";
    };

    signing = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable GPG signing";
      };

      key = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "GPG key ID";
      };
    };
  };

  config = mkIf config.modules.home.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = config.modules.home.git.userName;
          email = config.modules.home.git.userEmail;
          signingkey = mkIf config.modules.home.git.signing.enable config.modules.home.git.signing.key;
        };
        init.defaultBranch = "main";
        pull.rebase = true;
        push.autoSetupRemote = true;
        commit.gpgsign = mkIf config.modules.home.git.signing.enable true;
      };
    };

    programs.delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        features = "side-by-side line-numbers decorations";
        navigate = true;
      };
    };
  };
}
