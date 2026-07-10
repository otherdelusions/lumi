set shell := ["bash", "-uc"]

@_default:
    just --list

_pre:
    git add .

[doc('Rebuild the current host (or supply a different config to build). Use -b or --boot to boot instead of switching')]
[arg("action", long="boot", short="b", value="boot")]
rebuild target=shell('hostname') action='switch': _pre
    sudo nixos-rebuild {{action}} --flake .#{{target}}

[doc('Update all flake inputs')]
update:
    nix flake update

[doc('Run a flake check')]
check: _pre
    nix flake check

[doc('Format nix files using flake configured formatter')]
fmt:
    nix fmt .     

[doc('Collect garbage')]
gc:
    sudo nix-collect-garbage -d && nix-collect-garbage -d
    @just archive

[doc('Repair nix store')]
repair:
    sudo nix-store --verify --check-contents --repair

[doc('Archive flake inputs to nix store')]
archive:
    nix flake archive .

[doc('Print disk ids for a given device in /dev')]
@disk-id sdx:
    find -L /dev/disk/by-id -samefile /dev/{{sdx}} -printf '%f\n' | sort

[doc('Build an iso of a config')]
build-iso target='interloper':
    nix build .#nixosConfigurations.{{target}}.config.system.build.isoImage

[doc('Use disko setup of a given host to format and partition the current system')]
[confirm("This will erase all data on your disk and partition it as declared in disko target. Continue?")]
disko target: _pre
    sudo disko --mode destroy,format,mount --flake .#{{target}}

[doc('Install nixos using given host config')]
install target: _pre
    sudo nixos-install --flake .#{{target}} --no-root-password

[doc('Zip up all of the repo contents')]
zip:
    zip -r "./$(basename "$(pwd)")".zip . -x ".direnv/*" ".git/*"
    
