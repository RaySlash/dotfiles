{inputs}: {
  # stable-pkgs: This overlay adds the stable branch of nixpkgs under
  # `pkgs.stablePackages` to access stable branch.
  # Example: `home.packages = [pkgs.stablePackages.neovim];`
  stable-pkgs = final: _prev: {
    stablePackages = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  # custom-pkgs: This overlay adds all locally defined packages
  # under `customPackages`.
  # Example: `home.packages = [pkgs.customPackages.nvimcat];`
  custom-pkgs = final: _prev: {
    customPackages = import ./packages final.pkgs;
  };
  # Add home-manager CLI from inputs to `pkgs.home-manager-master`
  home-manager = final: _prev: {
    home-manager-master =
      inputs.home-manager.packages.${final.system}.home-manager;
  };
  # Add zen-browser to pkgs from flake input, two versions:
  # `pkgs.zen-browser`(Beta) & `pkgs.zen-browser-twilight`(Canary)
  zen-browser = final: _prev: {
    zen-browser-twilight = inputs.zen-browser.packages.${final.system}.twilight;
    zen-browser = inputs.zen-browser.packages.${final.system}.default.override {
      nativeMessagingHosts = [final.pkgs.firefoxpwa];
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        DisableFormHistory = true;
        DisablePocket = true;
      };
    };
  };
  nurpkgs = inputs.nurpkgs.overlays.default;
  nix-minecraft = inputs.nix-minecraft.overlay;
  neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;
  emacs = inputs.emacs-overlay.overlays.default;
}
