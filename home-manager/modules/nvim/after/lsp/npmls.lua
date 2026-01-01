-- REF https://github.com/AkisArou/npm-workspaces-lsp package this with Nix
return {
	cmd = { "npm-workspaces-lsp", "--stdio" },
	filetypes = { "json" },
	root_markers = { "package.json" },
	workspace_required = true,
}
