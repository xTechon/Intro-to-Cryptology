# from: https://flyx.org/nix-flakes-latex/
{
  description = "LaTeX Document Demo";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };
  outputs = { self, nixpkgs, flake-utils, nix-vscode-extensions }:
    with flake-utils.lib; eachSystem allSystems (system:
      let
        pkgs = import nixpkgs {inherit system; config.allowUnfree = true; };
        tex = pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small latex-bin latexmk texcount;
        };
        extensions = nix-vscode-extensions.extensions.${system};

        codium = pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscodium;
          vscodeExtensions = [
            extensions.open-vsx.bbenoist.nix
            extensions.open-vsx.jnoortheen.nix-ide
            extensions.open-vsx.asvetliakov.vscode-neovim
            extensions.open-vsx.zokugun.explicit-folding

            extensions.open-vsx.efoerster.texlab
            extensions.open-vsx.tecosaur.latex-utilities
            extensions.open-vsx.james-yu.latex-workshop
          ];
        };

        HW1Shell = pkgs.mkShell.override {} {
          packages = [
            codium
            pkgs.texlab # lsp
            tex # needed for development compilation
            pkgs.perl # needed for latex-workshop
          ];
          shellHook = ''
            export LABEL="HW1"
            alias code="codium Intro-to-Cryptology.code-workspace"
          '';
        };

      in
      rec {
        packages = {
          document = pkgs.stdenvNoCC.mkDerivation rec {
            name = "latex-demo-document";
            src = self;
            buildInputs = [ pkgs.coreutils tex ];
            phases = [ "unpackPhase" "buildPhase" "installPhase" ];
            buildPhase = ''
              export PATH="${pkgs.lib.makeBinPath buildInputs}";
              mkdir -p .cache/texmf-var
              env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
                latexmk -interaction=nonstopmode -pdf -lualatex \
                HW1/HW1.tex
            '';
            installPhase = ''
              mkdir -p $out
              cp document.pdf $out/
            '';
          };
        };
        defaultPackage = packages.document;

        devShells = {
          default = HW1Shell;
          HW1 = HW1Shell;
        };

      });
}
