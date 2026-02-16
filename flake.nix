{
  description = "Hobr NixOS";

  inputs = {
    # Flakelight
    flakelight.url = "github:nix-community/flakelight";

    # 软件源
    ## 官方
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    ## 官方稳定
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-unstable";

    # 环境
    ## Rootless
    impermanence.url = "github:nix-community/impermanence";
    ## 安全启动
    lanzaboote.url = "github:nix-community/lanzaboote";
    ## Disko
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## 用户
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## 安全
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 软件
    # VS Code
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ## 罗技
    solaar = {
      url = "github:Svenum/Solaar-Flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 桌面
    ## 主题
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flakelight,
      home-manager,
      ...
    }:
    let
      mkNixosSystem =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            # 导入所有 NixOS 模块
            ./modules/nixos

            # 导入 Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs; };
              home-manager.sharedModules = [ ./modules/home ];
            }

            # 导入主机配置
            ./hosts/${hostname}
          ];
        };
    in
    flakelight ./. {
      inherit inputs;

      systems = [
        "x86_64-linux"
      ];

      outputs.nixosConfigurations = {
        # 笔记本
        kanade = mkNixosSystem "kanade" "x86_64-linux";
        # 服务器
        yuzuru = mkNixosSystem "yuzuru" "x86_64-linux";
      };

      formatters."*.nix" = "nixfmt";
    };
}
