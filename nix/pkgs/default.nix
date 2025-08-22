final: prev: {
  claude-powerline = final.callPackage ./claude-powerline.nix { };
  hidapitester = final.callPackage ./hidapitester.nix { };
  kubectl = final.callPackage ./kubectl.nix { };
}
