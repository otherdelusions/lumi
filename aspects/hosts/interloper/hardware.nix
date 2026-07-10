{
  den.aspects.interloper.nixos =
    {
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      ];
    };
}
