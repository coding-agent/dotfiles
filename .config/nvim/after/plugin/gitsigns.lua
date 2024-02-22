require('gitsigns').setup{
    signs = {
        add          = { text = 'A' },
        change       = { text = 'U' },
        delete       = { text = 'X' },
        topdelete    = { text = 'X' },
        changedelete = { text = 'X' },
        untracked    = { text = '│' },
    },
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
        follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 100,
        ignore_whitespace = false,
        virt_text_priority = 100,
    },
    current_line_blame_formatter = 'Culprit: <author>, <author_time:%Y-%m-%d> - <summary>',
    sign_priority = 9,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    preview_config = {
        -- Options passed to nvim_open_win
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
    },
    yadm = {
        enable = false
    },

    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        map('n', '<leader>hp', gs.preview_hunk)
        map('n', '<leader>hb', function() gs.blame_line{full=true} end)
        map('n', '<leader>gs', ':Gitsigns toggle_current_line_blame<CR>')
        map('n', '<leader>gl', ':Gitsigns toggle_linehl<CR>')

    end
}
