return {
		diagnostics = {
			underline = true,
			update_in_insert = true,
			severity_sort = true,
		},
		on_init = function(client)
			if client.workspace_folders then
				local path = client.workspace_folders[1].name
				if
					path ~= vim.fn.stdpath("config")
					and (vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc"))
				then
					return
				end
			end
		end,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
				},
				workspace = {
					checkThirdParty = false,
					library = {},
				},
				diagnostics = {
					globals = {},
				},
				telemetry = {
					enable = false,
				},
				hint = { enable = true, arrayIndex = "Disable" },
			},
		},
	}
