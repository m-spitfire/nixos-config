{ lib, ... }:

{
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
    # # TODO: Required for Vikunja, but can I tighten it up?
    # authentication = lib.mkForce ''
    #   # TYPE  DATABASE        USER            ADDRESS                 METHOD
    #   local   all             all                                     trust
    #   host    all             all             127.0.0.1/32            trust
    #   host    all             all             ::1/128                 trust
    # '';
  };
}
