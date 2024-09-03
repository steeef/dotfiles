{
  stdenv,
  fetchurl,
  installShellFiles,
}: let
  version = "1.30.4";
  sources = {
    x86_64-linux = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/linux/amd64/kubectl";
        sha256 = "sha256-L/0CNxK7wak5Db2MDBUgHBZaadOUeH7wPto+zLS5rAY=";
      })
    ];
    aarch64-darwin = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/darwin/arm64/kubectl";
        sha256 = "sha256-l4Z02mIoLaaX2InDPgzDb0t+yzpNH/c/yT5ug4d9WUU=";
      })
    ];
  };
in
  stdenv.mkDerivation rec {
    inherit version;
    pname = "kubectl";
    srcs = sources.${stdenv.hostPlatform.system};

    dontUnpack = true;

    nativeBuildInputs = [installShellFiles];

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
      "aarch64-darwin"
    ];
  }
