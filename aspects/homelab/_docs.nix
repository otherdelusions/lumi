{ self, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      iconSize = "32";
      mkRow =
        name: reg:
        let
          nameCell = if reg.path != "" then "[`${name}`](${reg.path})" else "`${name}`";
          icon =
            if reg.iconUrl != "" then
              ''<img src="${reg.iconUrl}" width="${iconSize}" alt="${name} icon">''
            else
              "-";
          desc = if reg.description != "" then reg.description else "-";
        in
        "| ${nameCell} | ${desc} | ${icon} |";

      servicesTable = pkgs.writeTextFile {
        name = "homelab-services-table";
        text = ''
          | service | description | icon |
          | --- | --- | --- |
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkRow self.homelabServices)}
        '';
      };

      containersTable = pkgs.writeTextFile {
        name = "homelab-containers-table";
        text = ''
          | container | description | icon |
          | --- | --- | --- |
          ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkRow self.homelabContainers)}
        '';
      };

      mkApp =
        {
          name,
          desc,
          table,
          startMarker,
          endMarker,
        }:
        {
          type = "app";
          meta.description = desc;
          program = toString (
            pkgs.writeShellScript name ''
              dest=''${1:-./README.md}
              if [ ! -f "$dest" ]; then
                echo "$dest does not exist"
                exit 1
              fi
              if grep -q '${startMarker}' "$dest" && grep -q '${endMarker}' "$dest"; then
                awk -v docs=${table} '
                  /${startMarker}/ { print; while ((getline line < docs) > 0) print line; skip=1; next }
                  /${endMarker}/ { skip=0 }
                  !skip { print }
                ' "$dest" > "$dest.tmp" && mv "$dest.tmp" "$dest"
              elif ! grep -q '${startMarker}' "$dest" && ! grep -q '${endMarker}' "$dest"; then
                printf '${startMarker}\n' >> "$dest"
                cat ${table} >> "$dest"
                printf '${endMarker}\n' >> "$dest"
              fi
            ''
          );
        };

    in
    {
      apps = lib.mkIf (self.homelabServices != { } || self.homelabContainers != { }) {
        homelab-service-table = mkApp {
          name = "homelab-service-table";
          desc = "generate services markdown table, uses markers to position the table in a file";
          table = servicesTable;
          startMarker = "<!-- homelab-services:start -->";
          endMarker = "<!-- homelab-services:end -->";
        };

        homelab-container-table = mkApp {
          name = "homelab-container-table";
          desc = "generate containers markdown table, uses markers to position the table in a file";
          table = containersTable;
          startMarker = "<!-- homelab-containers:start -->";
          endMarker = "<!-- homelab-containers:end -->";
        };
      };
    };
}
