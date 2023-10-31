## Install HM:

```sh
nix profile install home-manager 
```

## Generate this repo:

We use this template

```sh
git init nix-config
cd nix-config
nix flake init -t github:misterio77/nix-starter-config#minimal
```

Then replace the `TODO` and `FIXME` in code, and replace system from `x86_64-linux` to the current system

## Init home manager

```sh
# nix run home-manager/release-23.05 -- init
# apply the config
home-manager --flake .#hugosum switch
```