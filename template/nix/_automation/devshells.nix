{
  inputs,
  cell,
}: let
  l = nixpkgs.lib // builtins;
  inherit (inputs) nixpkgs std;
in {
  default = std.lib.dev.mkShell {
    name = "Terra-Forma";
    nixago = [
      (std.std.nixago.treefmt {
        configData.formatter = {
          terraform = {
            command = "terraform";
            options = ["fmt"];
            includes = ["*.tf"];
          };
        };
      })
    ];
    commands = [
      {
        category = "tools";
        package = nixpkgs.terraform;
      }
      {
        category = "tools";
        package = nixpkgs.terraform-ls;
      }
      {
        category = "editors";
        name = "hx";
        package = nixpkgs.helix;
      }
      {
        category = "editors";
        package = nixpkgs.vim;
      }
    ];
  };
}
