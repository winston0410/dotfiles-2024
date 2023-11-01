local function init(paq)
	paq({
		"mhartington/formatter.nvim",
        commit = "34dcdfa0c75df667743b2a50dd99c84a557376f0",
		-- opt = true,
		-- keys = { { "n", trigger_key } },
		config = function()
			local function mintfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function javafmt()
				-- https://github.com/google/google-java-format
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function inifmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function nimfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function njkfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function liquidfmt()
				return {
					exe = "",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function dhall_format()
				return {
					exe = "dhall",
					args = { "format", "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function dhall_lint()
				return {
					exe = "dhall",
					args = { "lint", "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end
			local function elm_format()
				return {
					exe = "elm-format",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			local function styler()
				return {
					exe = "",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function swift_format()
				return {
					exe = "swift-format",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function clang_format()
				return {
					exe = "clang-format",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function fnlfmt()
				return {
					exe = "fnlfmt",
					args = { vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function prettier(opts)
				opts = opts or {}
				return function()
					return {
                        exe = "prettier",
                        args = {vim.api.nvim_buf_get_name(0)},
                        stdin = true
					}
				end
			end

			local function purty()
				return {
					exe = "purty",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function dockfmt()
				return {
					exe = "dockfmt",
					args = { "--write", "--", vim.api.nvim_buf_get_name(0) },
					stdin = true,
				}
			end

			local function hindent()
				return {
					exe = "hindent",
					-- args = {"-w", "--", vim.api.nvim_buf_get_name(0)},
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			local function rufo()
				return {
					exe = "rufo",
					args = { "--", vim.api.nvim_buf_get_name(0) },
					stdin = false,
				}
			end

			require("formatter").setup({
                logging = true,
                log_level = vim.log.levels.WARN,
				filetype = {
					html = { require("formatter.filetypes.javascript").prettier },
					xml = { require("formatter.filetypes.javascript").prettier },
					svg = { require("formatter.filetypes.javascript").prettier },
					css = { require("formatter.filetypes.javascript").prettier },
					scss = { require("formatter.filetypes.javascript").prettier },
					sass = { require("formatter.filetypes.javascript").prettier },
					less = { require("formatter.filetypes.javascript").prettier },
					javascript = { require("formatter.filetypes.javascript").prettier },
					typescript = { require("formatter.filetypes.javascript").prettier },
					javascriptreact = { require("formatter.filetypes.javascript").prettier },
					typescriptreact = { require("formatter.filetypes.javascript").prettier },
					["javascript.jsx"] = { require("formatter.filetypes.javascript").prettier },
					["typescript.jsx"] = { require("formatter.filetypes.javascript").prettier },
					sh = { require("formatter.filetypes.sh").shfmt },
					zsh = { require("formatter.filetypes.sh").shfmt },
					markdown = { require("formatter.filetypes.javascript").prettier },
					-- Use fixjson?
					json = { require("formatter.filetypes.javascript").prettier },
					yaml = { require("formatter.filetypes.javascript").prettier },
					toml = { require("formatter.filetypes.javascript").prettier },
					vue = { require("formatter.filetypes.javascript").prettier },
					svelte = {
						prettier({
							"--plugin-search-dir=.",
							"--plugin=prettier-plugin-svelte",
						}),
					},
					python = { require("formatter.filetypes.python").black },
					dockerfile = { dockfmt },
					-- No formatter for make
					make = {
						require("formatter.filetypes.javascript").prettier
					},
					ruby = { rufo },
					lua = { require("formatter.filetypes.lua").stylua },
					teal = { require("formatter.filetypes.lua").stylua },
					rust = { require("formatter.filetypes.rust").rustfmt },
					nix = { require("formatter.filetypes.nix").nixfmt },
					go = { require("formatter.filetypes.go").gofmt, require("formatter.filetypes.go").goimports },
					dart = { require("formatter.filetypes.dart").dartformat },
					haskell = { hindent },
					purescript = { purty },
					kotlin = { require("formatter.filetypes.kotlin").ktlint },
					java = { javafmt },
					fennel = { fnlfmt },
					cpp = { clang_format },
					c = { clang_format },
					cs = { clang_format },
					swift = { swift_format },
					r = { styler },
					elm = { elm_format },
					elixir = { require("formatter.filetypes.elixir").mixformat },
					sql = { require("formatter.filetypes.sql").pgformat },
					tf = { require("formatter.filetypes.terraform").terraformfmt },
					ini = { inifmt },
					dosini = { inifmt },
					dhall = { dhall_lint, dhall_format },
					pug = {
						prettier({
							"--plugin-search-dir=.",
							"--plugin=plugin-pug",
						}),
						--  Falling back with system plugin
						prettier({
							"--plugin-search-dir=$XDG_DATA_HOME/prettier",
							"--plugin=plugin-pug",
						}),
					},
					nunjucks = { njkfmt },
					liquid = { liquidfmt },
					mustache = {},
					wren = {},
					haml = {},
					nim = { nimfmt },
					mint = { mintfmt },
				},
			})

			vim.api.nvim_create_autocmd('BufWritePost', {
				pattern  = { "*" },
				command = "FormatWrite"
			})
		end,
	})
end

return { init = init }
