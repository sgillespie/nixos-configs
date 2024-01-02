{ pkgs, ... }:

{
  programs.zsh.enable = true;
  security.sudo.wheelNeedsPassword = false;

  nix.settings = {
    trusted-users = ["root" "@wheel"];
  };

  users.extraUsers = {
    root.initialHashedPassword = "";

    agillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
        "video"
      ];
    };

    sgillespie = {
      isNormalUser = true;
      extraGroups = [
        "docker"
        "wheel"
        "networkmanager"
        "vboxusers"
        "video"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2d1mSBAe0F3k/Hm3TWernnMupR2Bi/THOKycxVIvvi4lFWxd6yzoigti0Bfe9eLRqz62dI8N0kzF2FzUWSAsQs1OH55c8sZUUrv1WmJ9d8ande7Fe8QGAYrO2aYn4+PgySA8OO9Q6rqfvEfJlVPr+HpiVwU2/S9aa2hOo0dhweON8mQglgboGOhsUy2uPatHEguSSCBrKbVkA7/hxqctsENKYdKDtE9BOrE3ibM0Wa4DQ1oXLfSx9KvXBQisNYyiN/xAGzGhXCb/RPRpDTl/1HwYUGnBxmnINYeDhoIqSEnVtLJ++DwP3u93ZSXkuIbV1cq/YbdMxhXxV8Z95BdBxTY6uc2LEX6MtxdJfXmKloktpS6HbZXKZ+LWwq2dG/kDUzVBr0Ldqmr8dtZWGocVH3Lp4foGuRdeDgug9KZ8Ib7TYyocR9oo21olE8WwpkXDi8uZbn+zUKJNkGb/bT2FuMlJ+cL0tyDWmbwnT5CnJb2c31aGucGDKurkrI7bUAUxMoRynvccovlgwIPWvWBDU6FQG4meM5YfR+VboDlCtaFurcSnN+/baOAW5Jq0q4G4Fiy+Wg8k33I99ELUt6LlH1E+Z1do9gkRc8OOr2+1yyai5MSkX3NEpmI1JwylVQxnADip0HciMpFHPc6WgBV44q8QVlLfxFsxBxdqKardCNw== cardno:10_364_907"
      ];
      shell = pkgs.zsh;
    };
  };
}
