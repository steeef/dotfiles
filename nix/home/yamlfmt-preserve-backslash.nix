{pkgs}:
pkgs.stdenv.mkDerivation rec {
  pname = "yamlfmt";
  version = "0.21.0-0.0.1";

  src = pkgs.fetchurl {
    url = "https://github.com/steeef/yamlfmt/releases/download/v${version}/yamlfmt_${version}_${{
        "x86_64-linux" = "Linux_x86_64";
        "aarch64-linux" = "Linux_arm64";
        "x86_64-darwin" = "Darwin_x86_64";
        "aarch64-darwin" = "Darwin_arm64";
      }.${
        pkgs.stdenv.hostPlatform.system
      }}.tar.gz";
    hash =
      {
        "x86_64-linux" = "sha256-ZYCFM+/nBnaQOCScEi/YQJoH8lltk/90tXCa29RZIsQ=";
        "aarch64-linux" = "sha256-D73iIbLqbZMI2tEHnhi3WJ/64kxk+MLVlvivz+iUZzs=";
        "x86_64-darwin" = "sha256-H26KBEyPxQhsj8jFLLIJKOkLVfJobe+h6iGVyIve3dQ=";
        "aarch64-darwin" = "sha256-eyL5cyEtxzJ4qgzHba3eBsElkvqnBC86y8oSCEw19E8=";
      }.${
        pkgs.stdenv.hostPlatform.system
      };
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
    platforms = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    maintainers = [];
  };
}
