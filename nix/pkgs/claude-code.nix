{
  lib,
  stdenv,
  fetchurl,
  patchelf,
}:
# To update:
# 1. Set `version` to the new release version
# 2. Update all four SRI hashes by running:
#      VERSION="<new-version>"
#      BASE="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
#      for plat in linux-x64 linux-arm64 darwin-x64 darwin-arm64; do
#        echo "$plat:"
#        nix-prefetch-url --type sha256 "$BASE/$VERSION/$plat/claude" 2>/dev/null \
#          | xargs nix hash convert --from nix32 --to sri --hash-algo sha256
#      done
# 3. Run `hms` to build and verify
let
  version = "2.1.19";
  baseUrl = "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";

  platformMap = {
    x86_64-linux = {
      cdnPlatform = "linux-x64";
      hash = "sha256-Tiocc4cezzsTM3a1fe0DMzp6Y4fy0qOmJ5u5Cgf3qUQ=";
    };
    aarch64-linux = {
      cdnPlatform = "linux-arm64";
      hash = "sha256-jEthskynYNb3qi8ZcnFj0SLp/Qw86R8QaiG2kYp7G7s=";
    };
    x86_64-darwin = {
      cdnPlatform = "darwin-x64";
      hash = "sha256-viZrOpUvSD2DWK0UHir+ZhFwOGUG9Hnq2ZIxnk/cOKw=";
    };
    aarch64-darwin = {
      cdnPlatform = "darwin-arm64";
      hash = "sha256-04asj20UefhdMfNpQhyCQTXBAknDIIcBfQWl9CiFLEE=";
    };
  };

  platform = platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
assert !stdenv.hostPlatform.isMusl;
stdenv.mkDerivation {
  pname = "claude-code";
  inherit version;

  src = fetchurl {
    url = "${baseUrl}/${version}/${platform.cdnPlatform}/claude";
    hash = platform.hash;
  };

  dontUnpack = true;
  dontFixup = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

  installPhase = ''
    install -Dm755 $src $out/bin/claude
  '' + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --set-interpreter "$(cat ${stdenv.cc}/nix-support/dynamic-linker)" $out/bin/claude
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    HOME=$TMPDIR $out/bin/claude --version
  '';

  meta = {
    description = "Anthropic's CLI for Claude AI";
    homepage = "https://docs.anthropic.com/en/docs/claude-code";
    license = lib.licenses.unfree;
    mainProgram = "claude";
    platforms = builtins.attrNames platformMap;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
