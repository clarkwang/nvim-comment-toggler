-- vi:set ft=lua et sw=4:

local g = {
    default_key = '#',
    global_key_enable = false,

    filetypes = {
        foo = {
            marker = '##',
            key = '#',
        },
    },
}

local function ft_c_str()
    local ft = vim.bo.filetype

    if g.filetypes[ft] and g.filetypes[ft].marker then
        return g.filetypes[ft].marker
    end

    if not vim.bo.commentstring then
        return
    end

    --| Examples:
    --|   c  : /*%s*/
    --|   lua: -- %s
    --|   sh : # %s
    --|   vim: "%s
    local c_str = string.match(vim.bo.commentstring, '^([^ ]+) *%%s$')
    return c_str
end

local function ft_params()
    local c_str = ft_c_str()
    if not c_str or #c_str == 0 then
        return
    end

    return c_str, #c_str, string.rep(' ', #c_str)
end

local function toggle_line()
    local c_str, c_len, c_spaces = ft_params()
    if not c_str then
        return
    end

    -- `row' is 1-indexed
    -- `col' is 0-indexed
    local row, col = unpack(vim.api.nvim_win_get_cursor(0) )
    col = col + 1

    -- zero-based, end-exclusive
    local line = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]

    if col <= c_len then
        if line:sub(1, c_len) == c_str then
            -- remove `--' from the beginning of the line
            vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, c_len, { '' })

        elseif line ~= '' then
            -- add `--' to the beginning of the line
            vim.api.nvim_buf_set_text(0, row - 1, 0, row - 1, 0, { c_str })
        end

        -- `--' => `  '
    elseif line:sub(col - c_len, col - 1) == c_str then
        -- Indexing is zero-based.
        -- Row indices are end-inclusive, and
        -- column indices are end-exclusive.
        vim.api.nvim_buf_set_text(0, row - 1, col - c_len - 1, row - 1, col - 1, { c_spaces })

        -- `  ' => `--'
    elseif line:sub(col - c_len, col - 1) == c_spaces then
        vim.api.nvim_buf_set_text(0, row - 1, col - c_len - 1, row - 1, col - 1, { c_str })
    end

    -- move cursor down
    -- (1, 0)-indexed
    local line_count = vim.api.nvim_buf_line_count(0)
    if row < line_count then
        vim.cmd('norm j')
        return true
    else
        return false
    end
end

local function toggle_lines()
    for i = 1, vim.v.count1 do
        if not toggle_line() then
            break
        end
    end
end

local function setup(conf)
    local ft, spec
    local lua_cmd

    --
    -- global opts first
    --
    if conf.default_key then
        g.default_key = conf.default_key
    end
    if conf.global_key_enable ~= nil then
        g.global_key_enable = conf.global_key_enable
    end
    if g.global_key_enable then
        vim.keymap.set('n', g.default_key, toggle_lines, { noremap = true, silent = true })
    end

    --
    -- ft specific
    --
    for ft, spec in pairs(conf.filetypes or {}) do
        g.filetypes[ft] = spec

        lua_cmd = string.format("vim.keymap.set('n', '%s', require'comment-toggler'.toggle, { buffer = 0, noremap = true, silent = true })",
                                spec.key or g.default_key)
        vim.cmd(string.format('autocmd FileType %s lua %s', ft, lua_cmd) )
    end
end

return {
    setup = setup,
    toggle = toggle_lines,
}
