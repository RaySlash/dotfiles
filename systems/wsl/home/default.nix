{pkgs, ...}: {
  home.packages = with pkgs; [
    htop
    fd
    ripgrep
    lazygit
    unzip
    p7zip
    wget
    imv
  ];

  home.stateVersion = "24.05";
}
