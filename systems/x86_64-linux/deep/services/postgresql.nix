{lib, ...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "authelia-deep"
      "lldap"
    ];
    ensureUsers = [
      {
        name = "root";
        ensureClauses.superuser = true;
      }
      {
        name = "authelia-deep";
        ensureDBOwnership = true;
      }
      {
        name = "lldap";
        ensureDBOwnership = true;
      }
    ];
  };
}
