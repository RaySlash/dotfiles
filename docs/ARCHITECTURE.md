# Architecture [WIP]

## Table of Contents

- [Overview](#overview)
  - [System Builders](#builders)
  - [Modules](#modules)

## Overview

### Builders

There are a few builders that are necessary in creating system
configurations.

```nix
# In this scenerio, modules is the only arg
mkSystem = args: inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [] ++ args.modules;
};
```

In the above example, we can see that we are reusing the modules.
We can set our own common modules directly here. When one calls
the function `mkSystem`, they are expected to pass in path of the
configuration files that have nested inside the codebase.

> **NOTE:** Using this, end user can follow any folder convention
> without having to change the `mkSystem` function. This inputs
> possible due to it taking arguments which supply path to
> host-specific configurations.

An another approach to this would be to implement a convention
for directory structure and follow the pattern to create
host-specific configurations. Such a function would have a few
arguments such as `hostname`, `build-mode` and `users-list`.

- `hostname` : This resemble the name of the hose that the configuration
  is being built for. Usually this would be name of your system ( Example: `DESKTOP-X4DU44`
  or `frost`)

- `build-mode` : There would be three modes that the build system could export
  to. These modes resemble what configurations need to be loaded and built.

      1. `nixos`: This mode will only build configurations against the `nixosSystem`
      configurations defined.
      2. `hm`: This mode will only build configurations against home-manager
      defined.
      3. `nix_and_hm`: This mode would build NixOS configurations along with
      home-manager as a NixOS module.

- `users-list`: This list would contain username as strings in a list `[]`.
  For example, it can contain value such as:

```nix
users-list = ["user1" "user2"]
```

### Modules

Modules are the core part of configuration. We are using reusable modules for
mostly all the application that need custom configuration. All modules live at
`modules` directory. These contain NixOS and Home-manager modules categorized
according to the module specifications.

```nix
moduleSet = import ../modules {inherit inputs;};
```

In the build function, the modules are loaded in `modules/default.nix`. This will act as our
central place where we plug and un-plug modules into the flake. All the configurations
for `home-manager` are loaded as `moduleSet.homeModules`, whereas the configurations
for `nixos` are loaded as `moduleSet.osModules`.

> By default, all modules are loaded which are defined in `modules/default.nix`.

### Common Configurations

There are common configurations that need to be enabled for every system. These
configuration are loaded by default and live at `systems/common/`. These configurations
need to recursively updated with specific host configuration (example: `systems/frost`).
This is also valid for all `home-manager` cofnigurations as well.

```nix
inputs.nixpkgs.lib.recursiveUpdate (common) (specific)
```
