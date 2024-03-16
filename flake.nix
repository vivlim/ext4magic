{
  description = "a patched version of ext4magic that might not segfault on encrypted drives. patch from markusbauer@users.sourceforge.net https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=854497";
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  {
    packages = let
      pkgSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      packagesForEachSystem = f: nixpkgs.lib.genAttrs pkgSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
      });
    in packagesForEachSystem ({ pkgs }:
      let
        ext4magic = import ./ext4magic.nix pkgs; # needed to add `, ...` to the imported module's param list so it would be ok with the presence of other params like `system`
      in {
        default = ext4magic;
      });
  };
}
