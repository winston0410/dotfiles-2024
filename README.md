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

## Init and switch nix-darwin

```sh
nix run nix-darwin -- --flake .#hugosum switch
```

## Set up neovim

Set up packages

```
:PackerUpdate
:PackerCompile
```

Set up Treesitter

```
:TSUpdate all
```

Use checkhealth to confirm all parsers are working:

```
:checkhealth nvim-treesitter
```

If there are any parser has issue, reinstall them with:

```
:TSUpdate <parser-name>
```
