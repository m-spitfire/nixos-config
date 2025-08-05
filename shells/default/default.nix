{pkgs, ...}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    treefmt
    alejandra
    shfmt
    statix
    deadnix
  ];
}
