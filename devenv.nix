{
  pkgs,
  lib,
  ...
}: {
  name = "nixland";

  languages = {
    nix.enable = true;
    lua = {
      enable = true;
      package = pkgs.luajit;
    };
  };

  packages = with pkgs; [
    glow # for md files
  ];

  enterShell = ''
    ${lib.getExe pkgs.git} pull

    echo -e "\n\e[33m⚙ Welcome\e[0m \e[37mto the\e[0m \e[36m nixCats\e[0m \e[35mconfiguration development\e[0m \e[32mshell!\e[0m"

    ${lib.getExe pkgs.git} status
  '';

  git-hooks = {
    package = pkgs.prek;

    hooks = {
      # Basic hooks
      shellcheck.enable = true;
      end-of-file-fixer.enable = true;
      trim-trailing-whitespace.enable = true;
      detect-private-keys.enable = true;

      # Nix specific hooks
      alejandra.enable = true;
      statix.enable = true;
    };
  };
}
