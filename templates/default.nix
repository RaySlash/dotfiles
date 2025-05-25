let
  templates = [
    "c"
    "c-raylib"
    "elm"
    "nextjs"
    "rust"
    "zig-raylib"
    "zig"
  ];
in
  builtins.listToAttrs (map (name: {
      name = name;
      value = {
        path = ./${name};
        description = "Development environment flake for ${name}";
      };
    })
    templates)
