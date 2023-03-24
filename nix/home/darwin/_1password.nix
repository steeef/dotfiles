{ lib, pkgs, ... }: {
  home.activation."_1password" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # For TouchID to work in `op` 1Password CLI, it needs to be at `/usr/local/bin`
    # (Hopefully this requirement will be lifted by 1Password at some point)
    # NOTE we don't install `op` via nix but simply copy the binary
    $DRY_RUN_CMD mkdir -p /usr/local/bin
    $DRY_RUN_CMD cp ${pkgs._1password}/bin/op /usr/local/bin/op
  '';
}
