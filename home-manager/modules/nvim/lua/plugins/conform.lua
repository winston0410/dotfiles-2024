return {
	{
		"stevearc/conform.nvim",
		version = "9.x",
		event = { "BufWritePre" },
		cmd = { "ConformInfo", "ConformDisable", "ConformEnable" },
		config = function()
            -- REF https://github.com/stevearc/conform.nvim/issues/781
            -- biome might fail if biome.json does not exist
			local biome = { "biome", "prettierd", "prettier", stop_after_first = true }
            local clang_format = { "clang_format"}

			require("conform").setup({
                timeout_ms = 2000,
				formatters_by_ft = {
                    gdscript = {"gdformat"},
                    roc = {"roc"},
                    bicep = {"bicep"},
                    proto = {"buf"},
                    gn = {"gn"},
                    vhdl = {"ghdl"},
                    cedar = {"cedar"},
                    tf = {"tofu_fmt", "terraform_fmt", stop_after_first = true},
					ember = {},
					apex = {},
					astro = {},
					cuda = {},
					foam = {},
					fish = {"fish_indent"},
					glsl = {},
					hack = {},
					inko = {"inko"},
					julia = {},
					imba = {"imba_fmt"},
					rego = {"opa_fmt"},
                    bib = {"bibtex-tidy"},
					odin = {"odinfmt"},
					tact = {},
					nasm = {},
					slang = {},
					perl = {"perltidy"},
                    php = {"mago_format"},
					wgsl = {},
					html = biome,
					xml = biome,
					svg = biome,
					css = biome,
					scss = biome,
					sass = biome,
					less = biome,
					javascript = biome,
					javascriptreact = biome,
					["javascript.jsx"] = biome,
					typescript = biome,
					typescriptreact = biome,
					["typescript.jsx"] = biome,
					r = { "air" },
					sh = { "shfmt" },
					zsh = { "shfmt" },
					bash = { "shfmt" },
					markdown = vim.list_extend(biome, {"injected"}),
					json = biome,
					jsonl = {"biome"},
					jsonc = biome,
					json5 = biome,
					yaml = biome,
					vue = biome,
                    v = {"v"},
                    qml = {"qmlformat"},
					http = { "kulala-fmt" },
					toml = { "taplo" },
					lua = { "stylua" },
					teal = { "stylua" },
					scala = { "scalafmt" },
					python = function(bufnr)
						if require("conform").get_formatter_info("ruff_format", bufnr).available then
							return { "ruff_fix", "ruff_format" }
						else
							return { "isort", "black" }
						end
					end,
					rust = { "rustfmt", lsp_format = "fallback" },
					go = { "goimports", "gofmt" },
                    typespec = {"typespec"},
                    ansible = {"ansible-lint"},
					nix = { "nixfmt" },
					nginx = { "nginxfmt" },
					ruby = { "rufo" },
					dart = { "dart_format" },
					haskell = { "ormolu" },
					kotlin = { "ktlint" },
					cpp = clang_format,
					c = clang_format,
					cs = clang_format,
					java = clang_format,
					swift = { "swift" },
					elm = { "elm_format" },
					elixir = { "mix" },
					rescript = { "rescript-format" },
					crystal = { "crystal" },
					caramel = { "caramel_fmt" },
					dockerfile = { "dockerfmt" },
					sql = { "sqruff" },
					hcl = { "hcl" },
					ini = { "inifmt" },
					dosini = { "inifmt" },
					dhall = { "dhall_format" },
					fennel = { "fnlfmt" },
					svelte = biome,
					pug = biome,
					nu = { "nufmt" },
					nickel = { "nickel" },
					nunjucks = { "njkfmt" },
					liquid = { "liquidfmt" },
					nim = { "nimpretty" },
					mint = { "mintfmt" },
					kdl = { "kdlfmt" },
                    kcl = {"kcl"},
					just = { "just" },
					hurl = { "hurlfmt" },
					erb = { "erb_format" },
					ql = { "codeql" },
                    d = { "dfmt" },
                    jsonnet = {"jsonnetfmt"},
                    grain = {"grain_format"},
					d2 = { "d2" },
                    cue = { "cue_fmt"},
					erlang = { "efmt" },
					awk = { "gawk" },
					gleam = { "gleam" },
					zig = { "zigfmt" },
					fsharp = { "fantomas" },
                    fortran = {"fprettify"},
                    -- ["*"] = { "typos" },
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
					return { lsp_format = "fallback" }
				end,
				formatters = {},
			})
            require('conform').formatters.injected = {
                options = {
                  lang_to_ext = {
                    bash = "sh",
                    javascript = "js",
                  }
                }
            }
			local disable_autoformat = function(args)
				if args.bang then
					-- ConformDisable! will disable formatting just for this buffer
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
