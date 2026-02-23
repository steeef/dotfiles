{...}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_macchiato";
    };
    themes = {
      catppuccin_mocha = ./catppuccin_mocha.theme;
      catppuccin_frappe = ./catppuccin_frappe.theme;
      catppuccin_macchiato = ./catppuccin_macchiato.theme;
      catppuccin_latte = ./catppuccin_latte.theme;
    };
  };
}
