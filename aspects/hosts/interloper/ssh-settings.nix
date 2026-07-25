{
  den.aspects.interloper = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PermitEmptyPasswords = "yes";
        };
      };
    };
  };
}
