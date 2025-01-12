{
  lib,
  fetchgit,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "meteorbom";
  version = "0.1.0";

  src = fetchgit {
    url = "git@github.com:RaySlash/MeteorBOM.git";
    hash = "sha256-8KdiGORJ2q27l99c9tMrCRQwOit/WRTyrKgu6mmwqXM=";
  };

  cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";

  meta = with lib; {
    description = "A weather client";
    homepage = "https://github.com/RaySlash/meteorBOM";
    license = licenses.gpl3Plus;
    maintainers = [rayslash];
  };
}
