{inputs}: {
  # TODO: add nix-sops or agenix to manage sshKeys and password informations.
  cfg = {
    user = {
      # [REQUIRED] Default username that configurations will use
      name = "smj";
      # [REQUIRED] Default email address
      email = "45141270+RaySlash@users.noreply.github.com";
      # [REQUIRED] This would be the password set for a new nixos install
      # for the user under `cfg.user.name`
      # 0000
      initialHashedPassword = "$y$j9T$OHE2L5aEqg6F0WtDdHIML0$6Qnd4f.HFzL3n3k8w1QYyR5MC/z8SL.0gQwIjLNML5/";
      # [NOT RECOMMENDED] Default password for the user
      # hashedPassword = "";
      # [OPTIONAL] The ssh keys that will be installed throughout system only
      # if set explicitly
      # sshKeys = {
      #   private = "";
      #   public = "";
      # };
    };
  };
  # All utility functions written are loaded in this namespace
  lib = import ./utils/lib.nix {inherit inputs;};
}
