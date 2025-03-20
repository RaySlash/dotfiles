nixpkgs: type: path: let
  recMergePickDeeper = with builtins;
    lhs: rhs: let
      pred = path: lh: rh: ! isAttrs lh || ! isAttrs rh;
      pick = path: l: r:
        if isAttrs l
        then l
        else r;
      f = attrPath:
        zipAttrsWith (
          n: values: let
            here = attrPath ++ [n];
          in
            if length values == 1
            then head values
            else if pred here (elemAt values 1) (head values)
            then pick here (elemAt values 1) (head values)
            else f here values
        );
    in
      f [] [rhs lhs];

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
  targetFlake = with builtins; getFlake "path:${toString path}";
  getCfgs = lib.flip lib.pipe [
    (atp: lib.attrByPath atp {} targetFlake)
    builtins.attrValues
  ];
in
  lib.pipe type [
    (type: allTargets.${type})
    (map getCfgs)
    (builtins.foldl' (a: v: a ++ v) [])
    (builtins.foldl' recMergePickDeeper {})
    (v: v.options or {})
  ]
