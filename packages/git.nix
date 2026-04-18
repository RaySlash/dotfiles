{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.git ];

  config.configFile.content = ''
  [user]
  email = stevemathewjoy@tutanota.com
  name = RaySlash

  [init]
  defaultBranch = "master"
  '';
}

