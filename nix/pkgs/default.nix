final: prev: {
  hidapitester = final.callPackage ./hidapitester.nix { };
  kubectl = final.callPackage ./kubectl.nix { };
}
