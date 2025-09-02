-- load remaps
require("mooky.remap")

-- load line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- load split behavior
vim.opt.splitbelow = true
vim.opt.splitright = true

-- disable line wrapping
vim.opt.wrap = false

-- load tab config
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.scrolloff = 20 

vim.opt.virtualedit = "block"

vim.opt.inccommand = "split"

vim.opt.ignorecase = true

vim.opt.termguicolors = true

-- load lazy + plugins
require("mooky.lazy")

-- Show diagnostics in a floating window when cursor holds on a line with an error/warning
vim.o.updatetime = 200 -- Faster update time for CursorHold

vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        local opts = {
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            border = "rounded",
            source = "always",
            prefix = " ",
            scope = "line",
        }
        vim.diagnostic.open_float(nil, opts)
    end,
})

