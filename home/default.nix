{
  inputs,
  hub,
  ...
}: let
  username = hub.cfg.user.name;
  mkHome = args:
    hub.lib.mkHome {
      system = args.system;
      modules =
        [
          ./common.nix
        ]
        ++ (args.modules or []);
    };
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
