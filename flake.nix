{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    flakelight.url = "github:nix-community/flakelight";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      flakelight,
      ...
    }:
    flakelight ./. {
      imports = [ ];

      inherit inputs;
    };
}
