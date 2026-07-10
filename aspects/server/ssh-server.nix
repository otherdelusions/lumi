{ den, ... }:
{
  den.aspects.server.includes = [ den.aspects.server.ssh-server ];

  den.aspects.server.ssh-server = {
    nixos = {
      services.openssh = {
        enable = true;
        openFirewall = true;

        settings = {
          X11Forwarding = false;
          UseDns = false;
          StreamLocalBindUnlink = true;
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    };
  };
}
