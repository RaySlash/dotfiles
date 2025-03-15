{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    fd
    ripgrep
    lazygit
    unzip
    p7zip
    wget
    imv
  ];

  custom = {
    kitty.enable = true;
  };

  programs = {
    kitty = {
      settings = {
        hide_window_decorations = false;
      };
    };
  };

  home.stateVersion = "24.05";
}
