{ config, lib, pkgs, ... }: {
  home.activation.aliasApplications =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
      let
        apps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = [ "/Applications" ];
        };
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        echo "Linking Home Manager applications..."

        # only link per-user applications
        app_path="$HOME/Applications/Nix"
        tmp_path=$(mktemp -dt "home-manager-applications.XXXXXX") || exit 1

        if [[ -d "$app_path" ]]; then
          $DRY_RUN_CMD chmod -R +w "$app_path" 2>/dev/null || true
          $DRY_RUN_CMD rm -rf "$app_path"
        fi

        ${pkgs.fd}/bin/fd \
          -t l -d 1 . ${apps}/Applications \
          -x $DRY_RUN_CMD ${pkgs.mkalias}/bin/mkalias {} "$tmp_path/{/}"

        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      ''
    );
}
