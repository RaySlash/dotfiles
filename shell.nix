{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  packages = with pkgs; [
    coreutils
    fd
    ripgrep
    git
  ];
}
