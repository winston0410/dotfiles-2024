return {
	{
		"stevearc/conform.nvim",
		version = "9.x",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "ConformDisable", "ConformEnable" },
		config = function()
			-- TODO add a key binding for formatting operator
			-- TODO jump to specific kind of comments, for example TODO
			-- FIXME "biome" format is not working yet
			local prettier = { "prettierd", "prettier", stop_after_first = true }
			require("conform").setup({
				formatters_by_ft = {
					ember = {},
					apex = {},
					astro = {},
					bibtex = {},
					cuda = {},
					foam = {},
					fish = {},
					glsl = {},
					hack = {},
					inko = {},
					julia = {},
					odin = {},
					tact = {},
					nasm = {},
					slang = {},
					perl = {},
					wgsl = {},
					html = prettier,
					xml = prettier,
					svg = prettier,
					css = prettier,
					scss = prettier,
					sass = prettier,
					less = prettier,
					javascript = prettier,
					javascriptreact = prettier,
					["javascript.jsx"] = prettier,
					typescript = prettier,
					typescriptreact = prettier,
					["typescript.jsx"] = prettier,
					sh = { "shfmt" },
					zsh = { "shfmt" },
					bash = { "shfmt" },
					markdown = prettier,
					json = prettier,
					jsonl = prettier,
					jsonc = prettier,
					json5 = prettier,
					yaml = prettier,
					vue = prettier,
					http = { "kulala-fmt" },
					rest = { "kulala-fmt" },
					toml = { "taplo" },
					lua = { "stylua" },
					teal = { "stylua" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					rust = { "rustfmt", lsp_format = "fallback" },
					go = { "goimports", "gofmt" },
					nix = { "nixfmt" },
					nginx = { "nginxfmt" },
					ruby = { "rufo" },
					dart = { "dart_format" },
					haskell = { "hindent" },
					kotlin = { "ktlint" },
					cpp = { "clang_format" },
					c = { "clang_format" },
					cs = { "clang_format" },
					swift = { "swift_format" },
					r = { "styler" },
					elm = { "elm_format" },
					elixir = { "mix" },
					sql = { "pg_format" },
					tf = { "hcl" },
					ini = { "inifmt" },
					dosini = { "inifmt" },
					dhall = { "dhall_format" },
					fennel = { "fnlfmt" },
					svelte = prettier,
					pug = prettier,
					nunjucks = { "njkfmt" },
					liquid = { "liquidfmt" },
					nim = { "nimpretty" },
					mint = { "mintfmt" },
					kdl = { "kdlfmt" },
					just = { "just" },
					erb = { "erb_format" },
					ql = { "codeql" },
					d2 = { "d2" },
					erlang = { "efmt" },
					awk = { "gawk" },
					gleam = { "gleam" },
					rego = { "opa_fmt" },
					zig = { "zigfmt" },
				},
				default_format_opts = {
					lsp_format = "fallback",
				},
				format_on_save = function(bufnr)
					if vim.wo.diff then
						return
					end
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					return { timeout_ms = 500, lsp_format = "fallback" }
				end,
				formatters = {},
			})
			local disable_autoformat = function(args)
				if args.bang then
					-- FormatDisable! will disable formatting just for this buffer
					vim.b.disable_autoformat = true
				else
					vim.g.disable_autoformat = true
				end
			end
			local enable_autoformat = function()
				vim.b.disable_autoformat = false
				vim.g.disable_autoformat = false
			end
			vim.api.nvim_create_user_command("ConformDisable", disable_autoformat, {
				desc = "Disable autoformat-on-save",
				bang = true,
			})
			vim.api.nvim_create_user_command("ConformEnable", enable_autoformat, {
				desc = "Re-enable autoformat-on-save",
			})
		end,
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
