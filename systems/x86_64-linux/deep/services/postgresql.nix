_: {
  services.postgresql = {
    enable = true;
    ensureDatabases = [
      "authelia-deep"
      "lldap"
      "wikijs"
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
        name = "wikijs";
        ensureDBOwnership = true;
      }
    ];
  };
}
