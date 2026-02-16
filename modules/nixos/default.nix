# 集中导入所有 NixOS 模块
{ ... }:

{
  imports = [
    ./networking.nix
    ./users.nix
    ./desktop.nix
  ];
}
