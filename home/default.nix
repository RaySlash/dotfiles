{inputs, ...}: let
  username = inputs.self.localConfig.username;
  inherit (inputs.self.utils) mkHome;
in {
  "${username}@frost" = mkHome {
    system = "x86_64-linux";
    modules = [
      ./hosts/frost
    ];
  };
  "${username}@wsl" = mkHome {
    system = "x86_64-linux";
    modules = [
      ./hosts/wsl
    ];
  };
}
