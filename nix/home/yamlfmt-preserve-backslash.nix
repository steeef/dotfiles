{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "yamlfmt";
  version = "0.17.3-0.0.1";

  src = pkgs.fetchurl {
    url = "https://github.com/steeef/yamlfmt/releases/download/v${version}/yamlfmt_${version}_${{
      "x86_64-linux" = "linux_amd64";
      "aarch64-linux" = "linux_arm64";
      "x86_64-darwin" = "darwin_amd64";
      "aarch64-darwin" = "darwin_arm64";
    }.${pkgs.stdenv.hostPlatform.system}}.tar.gz";
    hash = {
      "x86_64-linux" = "";
      "aarch64-linux" = "";
      "x86_64-darwin" = "";
      "aarch64-darwin" = "sha256-PpY17V5vV7PpcIgOfRrCgHQyxXwEEtG9BkCx/M7NlK4=";
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
