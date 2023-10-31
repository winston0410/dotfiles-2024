## Generate this repo:

We use this template

```sh
git init nix-config
cd nix-config
nix flake init -t github:misterio77/nix-starter-config#minimal
```

Then replace the `TODO` and `FIXME` in code, and replace system from `x86_64-linux` to the current system

## Init and switch home manager

```sh
# REF https://github.com/nix-community/home-manager/issues/4533
nix run home-manager/release-23.05 -- --flake .#hugosum switch
```