# The flake.nix is the entrypoint of all nix code.
{
  description = "Terra-forma(cion) shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    std = {
      url = "github:divnix/std";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    std,
    ...
  } @ inputs:
    std.growOn {
      inherit inputs;

      cellsFrom = ./nix;

      cellBlocks = [
        (std.devshells "devshells")
      ];
    } {
      devShells = std.harvest self ["_automation" "devshells"];
    };
}
