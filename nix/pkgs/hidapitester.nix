{ stdenv, fetchurl, installShellFiles, unzip }:
let
  version = "0.3";
  sources = {
    x86_64-linux = [
      (fetchurl {
        url = "https://github.com/todbot/hidapitester/releases/download/0.3/hidapitester-linux-x86_64.zip";
        sha256 = "43735167696f17948cb833aa242d7c7c5d17100ee7bbc88793af602ae96389f7";
      })
    ];
    x86_64-darwin = [
      (fetchurl {
        url = "https://github.com/todbot/hidapitester/releases/download/${version}/hidapitester-macos-arm64-x86_64.zip";
        sha256 = "07d12bfcd830076c459e35df88a0a85840b989f6228324255da6c907ba53ebf2";
      })
    ];
  };
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "hidapitester";
  srcs = sources.${stdenv.hostPlatform.system};

  phases = [ "unpackPhase" "installPhase" ];

  nativeBuildInputs = [ installShellFiles unzip ];

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    for src in $srcs; do
      local name=$(stripHash $src)
      install -m755 -D $src $out/bin/$name
    done
  '';

  platforms = [
    "x86_64-linux"
    "x86_64-darwin"
  ];
}
