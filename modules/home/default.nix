# 集中导入所有 Home Manager 模块
{ ... }:

{
  imports = [
    ./shell.nix
    ./git.nix
    ./editors.nix
    ./development.nix
  ];
}
