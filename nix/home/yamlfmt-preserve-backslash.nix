{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "yamlfmt";
  version = "0.17.3-0.0.2";

  src = pkgs.fetchurl {
    url = "https://github.com/steeef/yamlfmt/releases/download/v${version}/yamlfmt_${version}_${{
      "x86_64-linux" = "Linux_x86_64";
      "aarch64-linux" = "Linux_arm64";
      "x86_64-darwin" = "Darwin_x86_64";
      "aarch64-darwin" = "Darwin_arm64";
    }.${pkgs.stdenv.hostPlatform.system}}.tar.gz";
    hash = {
      "x86_64-linux" = "sha256-qDGnn2bwg9XP7PtOB5PEu9sbrQxP1KmwMA1B4Ecl4+Y=";
      "aarch64-linux" = "sha256-x1XXKly9xIbAs9sbJ4xJoZIs6Z8LQ8O5J1NRxb39rb8=";
      "x86_64-darwin" = "sha256-tFgc58KO+mDUC6m2IyIlPH+/eldk5uA4GAU9w6/wn3w=";
      "aarch64-darwin" = "sha256-YfbEw0Vl2OgrGHUszRACJCETUNsUItv7CBzlDG17c80=";
    }.${pkgs.stdenv.hostPlatform.system};
  };

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/bin
    cp yamlfmt $out/bin/
    chmod +x $out/bin/yamlfmt
  '';

  meta = with pkgs.lib; {
    description = "yamlfmt with preserve_backslash formatter";
    homepage = "https://github.com/steeef/yamlfmt";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    maintainers = [ ];
  };
}
