{lib}: {
  build.nixos.hostname = lib.mkOption {
    type = with lib.types; uniq str;
    example = "my_host";
    description = ''
      Name for the host to build for.
      This would automatically mean you have to put
      host-specific configurations in system/<option-value>/configuration.nix
    '';
  };
}
