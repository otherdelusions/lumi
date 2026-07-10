{
  den.aspects.interloper.nixos =
    { lib, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = true;
        };
      };

      users.users.root = {
        password = "root";
        initialHashedPassword = lib.mkForce null;
      };
    };
}
