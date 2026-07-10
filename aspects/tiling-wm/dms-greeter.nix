{ den, inputs, ... }:
{
  den.aspects.tiling-wm.includes = [ den.aspects.tiling-wm.dms-greeter ];

  den.aspects.tiling-wm.dms-greeter =
    { host, user }:
    {
      nixos =
        { lib, ... }:
        let
          compositor = host.desktop.compositor;
        in
        {
          imports = [ inputs.dms.nixosModules.greeter ];

          programs.dank-material-shell.greeter = {
            enable = compositor != null;
            logs.save = lib.mkDefault true;
            configHome = "/home/${user.userName}";
            compositor.name = lib.mkIf (compositor != null) compositor;
          };

          users.users.${user.userName}.extraGroups = [ "greeter" ];

          # I updated this piece of shit and it started to
          # forget my username every reboot so here's
          # a temporary fix:
          #
          # sudo chown -R greeter:greeter /var/lib/dms-greeter
          # sudo chmod 750 /var/lib/dms-greeter
          # sudo systemctl restart greetd

          # systemd.services.greetd.preStart = ''
          #   cd /var/lib/dms-greeter
          #   ${config.programs.dank-material-shell.greeter.configHome}/.local/state/DankMaterialShell/session.json . || true
          #   chmod 644 memory.json || true
          #   chown greeter:greeter memory.json || true
          # '';
        };
    };
}
