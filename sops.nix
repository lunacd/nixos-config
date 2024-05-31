{ config, ... }:
{
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";

  sops.secrets = {
    haowenlPassword = {
      neededForUsers = true;
    };
    sshKey = {
      path = "/home/haowenl/.ssh/id_ed25519";
      owner = config.users.users.haowenl.name;
      mode = "0400";
    };

    # I know this looks stupid.
    # This is set up this way because keychain (see users/haowenl.nix) expects
    # the public key to be in the same directory as the REAL PATh of the
    # private key. Because sops-nix creates a symlink for the private key,
    # keychain expects the public key to be in /run/secrets rather than ~/.ssh.
    # Also, to prevent attacks made possible by knowing both the cleartext and
    # the secret, public key put in another sops file, which has a different
    # randomly generated encryption key.
    # Probably I should just create a symlink in /run/secrets, but I don't want
    # to figure out how, just yet.
    "sshKey.pub" = {
      sopsFile = ./secrets/public.yaml;
      path = "/home/haowenl/.ssh/id_ed25519.pub";
      owner = config.users.users.haowenl.name;
      mode = "0444";
    };

    gpgSecretKey = {
      path = "/home/haowenl/.gnupg/private-keys-v1.d/9B4E81F475201966EB39B23A1C63B067AC8043E7.key";
      owner = config.users.users.haowenl.name;
      mode = "0400";
    };
    gpgSubKey = {
      path = "/home/haowenl/.gnupg/private-keys-v1.d/1C8F393A442E526CC5F249E8B51EA9401F989B51key";
      owner = config.users.users.haowenl.name;
      mode = "0400";
    };

    pgadminPassword = {};
  };
}
