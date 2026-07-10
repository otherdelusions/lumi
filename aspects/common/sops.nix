{ den, inputs, ... }:
{
  den.aspects.common.includes = [ den.aspects.common.sops ];

  den.aspects.common.sops = {
    nixos =
      { host, pkgs, ... }:
      {
        imports = [
          inputs.sops-nix.nixosModules.sops
        ];

        environment.systemPackages = with pkgs; [
          sops
          age
          ssh-to-age
        ];

        services.openssh.hostKeys = [
          {
            type = "ed25519";
            path = "/etc/ssh/ssh_host_ed25519_key";
          }
        ];

        sops = {
          defaultSopsFile = ../../secrets/hosts + "/${host.name}.yaml";
          age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        };
      };
  };
}

# This knowledge is too dear to lose: Here is everything
# we can recall about the sops setup we built.
#
# .sops.yaml shows who can decrypt secret files.
# nix module shows where to look for encrypted secrets,
# who owns them and where descrypted secrets land.
#
# Editor user keys are only used for yaml file edits using sops.
# We generate them manually using age-keygen
# to ~/.config/sops/age/keys.txt
#
# Recipients:
# secrets/users/<user>.yaml - editors and each host the user is on
# secrets/hosts/<host>.yaml - editors and that host
#
# To add new host do:
# 1) cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age (on new host)
# 2) add pubkey to .sops.yaml
# 3) add the host section and add host to user secrets for that host
# 4) update keys
