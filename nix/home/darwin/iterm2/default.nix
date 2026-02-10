{lib, ...}: {
  home.activation."iterm2" = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD /usr/bin/defaults import com.googlecode.iterm2 ${./.}/com.googlecode.iterm2.plist
  '';
}
