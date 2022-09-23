{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "deco";
  home.homeDirectory = "/Users/deco";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    thefuck
    neofetch
    noto-fonts
    fira-code
    overpass
    nerdfonts
    jq
    nixfmt
    # Languages
    # Agda
    (agda.withPackages [ agdaPackages.standard-library ])
    # Node (mostly for purescript)
    nodejs
    esbuild # why isnt this included
    # Purescript
    purescript
    spago
    nodePackages.purescript-language-server
    # Haskell
    # Dhall
    dhall-lsp-server
  ];

  # Enable font cache
  fonts.fontconfig.enable = true;

  programs.fzf.enable = true;
  programs.vscode.enable = true;
  programs.alacritty = import ./programs/alacritty.nix;
  programs.fish = import ./programs/fish.nix { inherit pkgs; };
  programs.git = import ./programs/git.nix;
  programs.ssh = import ./programs/ssh.nix;
}
