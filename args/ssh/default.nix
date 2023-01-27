{ ... }:
{
  enable = true;
  compression = false;
  controlMaster = "auto";
  controlPath = "~/.ssh/cm_socket/%r@%h:%p";
  includes = [ "config_nortical"];

  matchBlocks = {
    "aur.archlinux.org" = {
      user = "aur";
      identityFile = "aur";
    };

    router = {
      hostname = "192.168.99.1";
      user = "root";
      identityFile = "id_rsa";
      extraOptions = {
        "HostKeyAlgorithms" = "+ssh-rsa";
        "PubkeyAcceptedAlgorithms" = "+ssh-rsa";
      };
    };

    mediacenter = {
      hostname = "192.168.99.99";
      user = "pi";
      identityFile = "id_rsa";
    };
  }; 
  extraConfig = ''
    Ciphers aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
  '';
}
