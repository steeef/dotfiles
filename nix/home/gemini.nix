{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.gemini-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
