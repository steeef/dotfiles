{ lib, ... }: {
  home.activation."create_directories" = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD mkdir -p $HOME/bin
    $DRY_RUN_CMD mkdir -p $HOME/code
    $DRY_RUN_CMD mkdir -p $HOME/build
  '';
}
