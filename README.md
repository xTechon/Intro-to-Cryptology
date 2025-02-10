### Intro to Cryptology Classwork

Classwork for my Intro to Cryptology Class.
First time Using texLive/Latex in any major capcity.
<br> Uses [nix](https://nixos.org/guides/how-nix-works/) [flakes](https://wiki.nixos.org/wiki/Flakes#) ([video](https://youtu.be/JCeYq72Sko0)) for consistent development environments.

Follows similar format as [Embedded Systems Classswork Repo](https://github.com/xTechon/Embedded-Systems).

`nix develop .#[assignment name]` to enter the development environment if you have [nix installed](https://github.com/DeterminateSystems/nix-installer).
I also provide a VSCodium in the flake with texLive LSP and Extensions for development

The `macros` file is provided by my professor to assist with the syntax for the class

e.g. 
```
# opens codium workspace in the HW1 dev shell
nix develop .#HW1 --command codium Intro-to-Cryptology.code-workspace
```
I have been trying to get `nix build` to get the Assignment PDFs to output consistently without using VSCodium to little success.
