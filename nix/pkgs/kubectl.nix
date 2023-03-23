{ stdenv, fetchurl, installShellFiles }:
let
  version = "1.25.5";
  sources = {
    x86_64-linux = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/linux/amd64/kubectl";
        sha256 = "6a660cd44db3d4bfe1563f6689cbe2ffb28ee4baf3532e04fff2d7b909081c29";
      })
    ];
    x86_64-darwin = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/darwin/amd64/kubectl";
        sha256 = "d2d63e0096b14e2c150bd8a1a50964aa1b917c98423f6fcb93b63e4ca3d2271a";
      })
    ];
  };
in
stdenv.mkDerivation rec {
  inherit version;
  pname = "kubectl";
  srcs = sources.${stdenv.hostPlatform.system};

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    for src in $srcs; do
      local name=$(stripHash $src)
      install -m755 -D $src $out/bin/$name
      installShellCompletion --cmd $name \
      --zsh <($out/bin/kubectl completion zsh)
    done
  '';

  platforms = [
    "x86_64-linux"
    "x86_64-darwin"
  ];
}
