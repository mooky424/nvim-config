return {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-jdtls", -- REQUIRED for Java
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup()
        mason_lspconfig.setup({
            ensure_installed = { "lua_ls", "pyright", "jdtls" },
            automatic_enable = false,
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({})
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim" },
                                },
                            },
                        },
                    })
                end,
                ["jdtls"] = function()
                    local jdtls = require("jdtls")

                    -- detect project root by .classpath / .project
                    local root_markers = { ".git", ".project", ".classpath" }
                    local root_dir = lspconfig.util.root_pattern(unpack(root_markers))(vim.fn.getcwd())

                    if root_dir == nil then
                        vim.notify("No Java project root found", vim.log.levels.WARN)
                        return
                    end

                    -- workspace dir per project
                    local home = os.getenv("HOME")
                    local workspace_dir = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

                    local config = {
                        cmd = { "jdtls", "-data", workspace_dir },
                        root_dir = root_dir,
                        settings = {
                            java = {
                                signatureHelp = { enabled = true },
                                completion = {
                                    favoriteStaticMembers = {
                                        "org.junit.Assert.*",
                                        "org.mockito.Mockito.*",
                                        "org.mockito.ArgumentMatchers.*",
                                        "org.mockito.Answers.*",
                                    },
                                    importOrder = { "java", "javax", "org", "com" },
                                },
                                configuration = {
                                    runtimes = {
                                        {
                                            name = "JavaSE-1.8",
                                            path = "/usr/lib/jvm/java-8-openjdk", -- adjust
                                        },
                                        {
                                            name = "JavaSE-17",
                                            path = "/usr/lib/jvm/java-17-openjdk", -- adjust
                                        },
                                    },
                                },
                                project = {
                                    referencedLibraries = {
                                        root_dir .. "/../libjars/*.jar",
                                    },
                                },
                            },
                        },
                    }

                    -- start or attach
                    jdtls.start_or_attach(config)
                end,
            },
        })
    end,
}

