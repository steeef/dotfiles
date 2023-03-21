{ ... }: {
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        indent_style = "space";
      };
      "*.json" = {
        indent_size = 2;
      };

      "*.{yaml,yml}" = {
        indent_size = 2;
      };
      "*.py" = {
        indent_size = 4;
      };
      "Makefile" = {
        indent_style = "tab";
      };
    };
  };
}
