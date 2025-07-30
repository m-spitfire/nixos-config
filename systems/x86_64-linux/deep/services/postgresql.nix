{lib, ...}: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "authelia-deep"
      "lldap"
      "vikunja"
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
      {
        name = "vikunja";
        ensureDBOwnership = true;
      }
    ];
  };
}
