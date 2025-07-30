{...}: final: prev: {
  vikunja = prev.vikunja.overrideAttrs {
    version = "0.24.1-1665-c3033441";
    src = prev.fetchFromGitHub {
      owner = "go-vikunja";
      repo = "vikunja";
      rev = "c303344183aa3bd26eabbfc05dd05756a9b71a8e";
      hash = "sha256-fUFcMs+6f8M7gkSxCBZo0kEjwY5X9iTn1AJ2Ehakr3U=";
    };
    vendorHash = "sha256-OYkgsGSl2kBSSz21g+kBbZcfEN+WfyFrrNkldww+F2U=";
    checkPhase = "";
  };
}
