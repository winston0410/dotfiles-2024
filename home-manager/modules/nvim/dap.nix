{ inputs, lib, config, pkgs, unstable, ... }: {
  home.packages = with pkgs; [
    delve # golang debugger
    netcoredbg # csharp
    vscode-js-debug
  ];
}
