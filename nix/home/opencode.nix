{
  inputs,
  pkgs,
  ...
}: {
   programs.opencode = {
     settings = {
       model = "gpt-5.1";
       theme = "catppuccin";
     };

    enable = true;
    package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
    rules = builtins.readFile ./claude/memory.md;
  };
}
