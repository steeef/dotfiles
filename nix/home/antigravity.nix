{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.antigravity-cli.packages.${pkgs.stdenv.hostPlatform.system}.antigravity-cli
  ];
}
