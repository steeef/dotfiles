{
  stdenv,
  fetchurl,
  installShellFiles,
}: let
  version = "1.32.6";
  sources = {
    x86_64-linux = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/linux/amd64/kubectl";
        sha256 = "sha256-DjHr+IJXi1DlD+bEPjoOPbYfakHJze1GSFvHTQPVdus=";
      })
    ];
    aarch64-darwin = [
      (fetchurl {
        url = "https://dl.k8s.io/release/v${version}/bin/darwin/arm64/kubectl";
        sha256 = "sha256-ishHRzpnlN010rmAySSbed7bbiNNAP0PIjz2tnvhKZk=";
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
