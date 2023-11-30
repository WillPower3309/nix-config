{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;
  };

  home = {
    packages = with pkgs; [
      # Language Servers
      rnix-lsp # nix
      clang-tools # c / cpp
      yaml-language-server
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
    ];

    #file.".emacs.d/init.el".source = ./config/emacs/init.el;
    persistence."/nix/persist/home/will".directories = [
      ".config/emacs"
      ".config/doom"
    ];
  };
}
