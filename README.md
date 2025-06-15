## Generate this repo:

We use this template

```sh
git init nix-config
cd nix-config
nix flake init -t github:misterio77/nix-starter-config#minimal
```

Then replace the `TODO` and `FIXME` in code, and replace system from `x86_64-linux` to the current system

## Init and switch home manager

Once we made changes to our setup, we need to run the `switch` command to apply the changes, as the configuration file is controlled by nix.

```sh
# REF https://github.com/nix-community/home-manager/issues/4533
# The version of home-manager in run here, has to match the version of home-manager being used in flake.nix
nix run home-manager/release-25.05 -- --flake .#linux switch
# if we wnat to build for darwin platform
nix run home-manager/release-25.05 -- --flake .#darwin switch
```

And to run in WSL layer:

```sh
sudo mkdir -p /etc/nix
sudo touch /etc/nix/nix.conf
sudo echo 'extra-experimental-features = nix-command flakes' > /etc/nix/nix.conf
nix run home-manager/release-25.05 -- --flake .#wsl switch
```

## Switch nixos system

```sh
# use-remote-sudo or sudo is needed to run this command correctly
nixos-rebuild switch --flake .#hugo --use-remote-sudo
```

## Init and switch nix-darwin

```sh
nix run nix-darwin -- --flake .#hugosum switch
```

## Update flake input without pinned to commit

```sh
nix flake update
```

## Set up Neovim

Install all plugins in Neovim, using Vim command panel:

```sh
:Lazy update
```

## Clean up home-manager

Somehow home-manager's generations are not automatically cleaned by NixOS GC at the moment. To clean up, you have to run the following command:

```sh
# it will retain only the latest generation
nix run home-manager/release-25.05 -- --flake .#linux expire-generations "-1 days"
```
