{
  description = "Some Infinity Engine mods (eg for Baldur's Gate)";
  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" ];
      forAllSystems = f:
        nixpkgs.lib.genAttrs allSystems
        (system: f { pkgs = import nixpkgs { inherit system; }; });
    in {
      packages = forAllSystems ({ pkgs }:
        let
          mod = args@{ ... }:
            args // {
              dontBuild = true;
              installPhase = ''
                mkdir $out
                cp -r * $out/
              '';
            };
          zipMod = args@{ ... }:
            (mod args // { nativeBuildInputs = [ pkgs.unzip ]; });
        in with pkgs.stdenv; {
          cdtweaks = mkDerivation (zipMod rec {
            pname = "cdtweaks";
            version = "16";
            src = pkgs.fetchurl {
              url =
                "https://github.com/Gibberlings3/Tweaks-Anthology/releases/download/v${version}/lin-cdtweaks-v${version}.zip";
              sha256 = "sha256-AyJ0SpxyMNqEuRmmAjNeBW82XWfXgUoGxxvIdM+0vl0=";
            };
          });

          scs = mkDerivation (zipMod rec {
            pname = "scs";
            version = "34.3";
            src = pkgs.fetchurl {
              url =
                "https://github.com/Gibberlings3/SwordCoastStratagems/releases/download/v${version}/lin-stratagems-${version}.zip";
              sha256 = "sha256-Se0gRBP7heFHQXfK3a564W7AKlyBrjegCa/nC9LnSE0=";
            };
          });

          BGForgeNetTweaks = mkDerivation (zipMod rec {
            pname = "BGForgeNetTweaks";
            version = "8.26";
            src = pkgs.fetchurl {
              url =
                "https://github.com/BGforgeNet/bg2-tweaks-and-tricks/releases/download/v${version}/tweaks-and-tricks-v${version}.zip";
              sha256 = "sha256-l28PU7EdrLn3fk95b3lbU32NcCHW0HIWi4bJ/6Sz6L0=";
            };
          });

          item_rand = mkDerivation (mod rec {
            pname = "item_rand";
            version = "7";
            src = fetchTarball {
              url =
                "https://github.com/FredrikLindgren/randomiser/releases/download/v${version}/lin-randomiser-v${version}.tar.gz";
              sha256 =
                "sha256:0ipl6fjy25l9wqmanx71phx2sc9y173r3hg25mx2rbpm3fafq7gr";
            };
          });
        });
    };
}
