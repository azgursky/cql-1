# Nix package for development
#
## INSTALL
#
# To build and install the packages in the user environment, use:
#
# $ nix-env -f . -i
#
## BUILD ONLY
#
# To build the packages and add it to the nix store, use:
#
# $ nix-build
#
## SHELL
#
# To launch a shell with all dependencies installed in the environment:
#
# $ nix-shell -A aql
#
# After entering nix-shell, build it:
#
# $ make
#
## NIXPKGS
#
# For all of the above commands, nixpkgs to use can be set the following way:
#
# a) by default it uses nixpkgs pinned to a known working version
#
# b) use the default nixpkgs from the system:
#    --arg pkgs 0
#
# c) use nixpkgs from an URL
#    --arg pkgs 0 -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/18.03.tar.gz
#
# c) use nixpkgs at a given path
#    --arg pkgs /path/to/nixpkgs

{
 pkgs ? null,
}:

let
  syspkgs = import <nixpkgs> { };
  pinpkgs = syspkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";

    # binary cache exists for revisions listed in https://nixos.org/channels/<channel>/git-revision
    rev = "0ab8fa2181a5d6561de673a91d51a2a082622328";
    sha256 = "1ldhn86pk7ajmkicm33h0lbipgvx439mll3llabkmr330lyrkgpz";
  };
  usepkgs = if null == pkgs then
             import pinpkgs {}
            else
              if 0 == pkgs then
                import <nixpkgs> { }
              else
                import pkgs {};
  stdenv = usepkgs.stdenvAdapters.keepDebugInfo usepkgs.stdenv;

in {
  aql = usepkgs.haskellPackages.callPackage ./aql.nix { };
  aql-js = usepkgs.haskell.packages.ghcjs.callPackage ./aql-js.nix { };
}