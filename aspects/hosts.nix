{
  den.hosts.x86_64-linux = {
    ash = {
      users.delusion = {
        authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyfwM5xpexbGKqVwGGOUvsIUjafEAmkFR3mgyMNRoLe delusion@ember"
        ];
      };
    };

    ember = {
      desktop.compositor = "niri";
      desktop.terminal = "foot";

      users.delusion = { };
    };

    interloper = { };
  };
}
