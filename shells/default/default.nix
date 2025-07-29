{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt

    alejandra
    shfmt
    nil
    yaml-language-server
  ];
}
