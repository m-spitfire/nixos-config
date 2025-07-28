let
  deep = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEG4IWkcCJgo/txFeBObZ4uZstBzOXnNH5dGtHNj8x39";
in
{
  "deep_authelia_hmac_secret.age".publicKeys = [ deep ];
  "deep_authelia_jwks.age".publicKeys = [ deep ];
  "deep_authelia_jwt_secret.age".publicKeys = [ deep ];
  "deep_authelia_session_secret.age".publicKeys = [ deep ];
  "deep_authelia_storage_encryption_key.age".publicKeys = [ deep ];
  "deep_authelia_lldap_authelia_password.age".publicKeys = [ deep ];

  "deep_lldap_jwt_secret.age".publicKeys = [ deep ];
  "deep_lldap_key_seed.age".publicKeys = [ deep ];
  "deep_lldap_admin_password.age".publicKeys = [ deep ];

  "deep_actual_client_secret.age".publicKeys = [ deep ];

  "deep_memos_client_secret.age".publicKeys = [ deep ];
}
