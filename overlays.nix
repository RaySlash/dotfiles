{ inputs }:
{
  # stable-pkgs: This overlay adds the stable branch of nixpkgs under
  # `pkgs.stablePackages` to access stable branch.
  # Example: `home.packages = [pkgs.stablePackages.neovim];`
  stable-pkgs = final: _prev: {
    stablePackages = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
  # custom-pkgs: This overlay adds all locally defined packages
  # under `customPackages`.
  # Example: `home.packages = [pkgs.customPackages.nvimcat];`
  custom-pkgs = final: _prev: {
    customPackages =
      let
        pkgs = final.pkgs;
      in
      import ./packages { inherit pkgs inputs; };
  };
  # Add zen-browser to pkgs from flake input, two versions:
  # `pkgs.zen-browser`(Beta) & `pkgs.zen-browser-twilight`(Canary)
  zen-browser = final: _prev: {
    zen-browser-twilight = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.twilight;
    zen-browser = inputs.zen-browser.packages.${final.stdenv.hostPlatform.system}.default.override {
      # nativeMessagingHosts = [final.pkgs.firefoxpwa];
      extraPolicies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = true;
        DisableFormHistory = true;
        DisablePocket = true;
      };
    };
  };
  nix-cachyos-kernel = inputs.nix-cachyos-kernel.overlays.default;
  nurpkgs = inputs.nurpkgs.overlays.default;
}
