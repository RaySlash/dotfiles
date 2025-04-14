{
  lib,
  flake-parts-lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    types
    ;
in {
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      hub = mkOption {
        type = types.lazyAttrsOf types.raw;
        default = {};
        description = ''
          Instantiated base user configuration and libs for local flake

          This options contains all information about user and specific
          fields that are used throughout modules. This hub acts as a central
          place for all configuration under `cfg` and utility library functions
          under `lib`.

          Example: `outputs.hub.cfg` return `{ user = { name = ""; }; }`
          Example: `outputs.hub.lib` return util functions for building
                   home-manager and nixos such as `mkSystem`, `mkHome` etc.
        '';
      };
    };
  };
}
