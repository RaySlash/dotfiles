nixpkgs: let
  pkgs = import nixpkgs {};
  inherit (pkgs) lib;
  allTargets = {
    nixos = [
      ["outputs" "nixosConfigurations"]
      ["outputs" "legacyPackages" "${pkgs.system}" "nixosConfigurations"]
    ];
    home-manager = [
      ["outputs" "homeConfigurations"]
      ["outputs" "legacyPackages" "${pkgs.system}" "homeConfigurations"]
    ];
    darwin = [
      ["outputs" "darwinConfigurations"]
      ["outputs" "legacyPackages" "${pkgs.system}" "darwinConfigurations"]
    ];
  };
in
  type: path:
    lib.pipe type (let
      targetFlake = with builtins; getFlake "path:${toString path}";
      getCfgs = lib.flip lib.pipe [
        (atp: lib.attrByPath atp {} targetFlake)
        builtins.attrValues
      ];
    in [
      (type: allTargets.${type})
      (map getCfgs)
      (builtins.foldl' (a: v: a ++ v) [])
      lib.mergeAttrsList
      (v: v.options)
    ])
