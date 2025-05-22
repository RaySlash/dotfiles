{ inputs
  , lib ? inputs.nixpkgs.lib
  , utils ? inputs.nixCats.utils
  , pkgs ? import inputs.nixpkgs {}
}:{
  # Make the derivation buildable by all available platforms in nixpkgs
  forEachSystem = utils.eachSystem lib.platforms.all;

  # Function that gives a list of treesitter grammers
  # This takes emacsPackages as first argument and grammerPackage list
  # with only the suffix names as second argument.
  # Use this instead of `epkgs.treesit-grammers.with-all-grammers`
  mkTreeSitterGrammers = epkgs: grammerlist: with epkgs; [
    tree-sitter
    (treesit-grammars.with-grammars (grammer:
    let
      # Function adds a supplied "prefix with first argument" to all elements
      # in "list as second argument" 
      addPrefixForEach = prefix: list: (map (item: "${prefix}${item}") list);
    in
      (with grammer;
	(addPrefixForEach "tree-sitter-" grammerlist))))
  ];

}
