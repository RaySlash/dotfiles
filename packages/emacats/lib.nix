{ inputs
  , lib ? inputs.nixpkgs.lib
}: 
let
  inherit (lib) foldl' attrNames elem;
in {
  # Make the derivation buildable by all available platforms in nixpkgs
  forEachSystem = let
    /**
    `flake-utils.lib.eachSystem` but without the flake input

    Builds a map from `<attr> = value` to `<attr>.<system> = value` for each system

    ## Arguments

    - `systems` (`listOf strings`)

    - `f` (`functionTo` `AttrSet`)

    ---
    */
      eachSystem = systems: f: let
	# get function result and insert system variable
	op = attrs: system: let
	  ret = f system;
	  op = attrs: key: attrs // {
            ${key} = (attrs.${key} or { })
          // { ${system} = ret.${key}; };
	  };
	in foldl' op attrs (attrNames ret);
	# Merge together the outputs for all systems.
      in foldl' op { } (systems ++
    (if builtins ? currentSystem && ! elem builtins.currentSystem systems
    # add the current system if --impure is used
    then [ builtins.currentSystem ]
    else []));
  in
    eachSystem lib.platforms.all;
}
