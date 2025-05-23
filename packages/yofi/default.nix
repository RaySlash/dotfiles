{
  lib,
  fetchFromGitHub,
  rustPlatform,
  autoPatchelfHook,
  fontconfig,
  libxkbcommon,
  pkg-config,
  ...
}: let
  buildDeps = [fontconfig libxkbcommon pkg-config];
in
  rustPlatform.buildRustPackage rec {
    pname = "yofi";
    version = "0.2.2";

    src = fetchFromGitHub {
      owner = "l4l";
      repo = "yofi";
      rev = version;
      hash = "sha256-cepAZyA4RBgqeF20g6YOlZTM0aRqErw17yuQ3U24UEg=";
    };

    cargoHash = "sha256-iSy/y1iwhR8x3wDIfazMeROSrJ8uRyA10hoNo6y2OQc=";
    buildInputs = buildDeps;
    nativeBuildInputs = buildDeps;

    postFixup = ''
      patchelf $out/bin/yofi --add-rpath ${lib.makeLibraryPath buildDeps}
    '';

    checkFlags = [
      # Fail to run in sandbox environment.
      "--skip=screen::context::test"
    ];

    meta = {
      description = "A minimalist app launcher in Rust";
      homepage = "https://github.com/l4l/yofi";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [rayslash];
      mainProgram = "yofi";
    };
  }
