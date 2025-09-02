return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
        scope = {
            enabled = true,
            show_start = true,
            show_end = true,
            highlight = { "Function", "Label" },
        },
    },
    config = function(_, opts)
        require("ibl").setup(opts)
    end,
}
