{
  enable = true;
  matchBlocks."*".extraOptions = {
    AddKeysToAgent = "yes";
    UseKeychain = "yes";
    IdentityFile = "~/.ssh/id_ed25519";
  };
}
