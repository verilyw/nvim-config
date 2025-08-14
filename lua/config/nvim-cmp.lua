local has_lspkind, lspkind = pcall(require, 'lspkind')
local cmp = require'cmp'

local function has_words_before()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    local col = cursor[2]
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup {
    -- view = 'custom',
    preselect = 'none',
    completion = {
        completeopt = 'menu,menuone,noinsert,noselect'
        -- completeopt = 'menu,menuone'
    },
    -- experimental = { ghost_text = true },

    -- 指定 snippet 引擎
    snippet = {
        expand = function(args)
            -- -- For `vsnip` users.
            -- vim.fn["vsnip#anonymous"](args.body)
            -- For `luasnip` users.
            -- require('luasnip').lsp_expand(args.body)
            -- For `ultisnips` users.
            -- vim.fn["UltiSnips#Anon"](args.body)
            -- For `snippy` users.
            -- require'snippy'.expand_snippet(args.body)
        end,
    },

    -- 来源
    sources = cmp.config.sources {
        -- {name = "lazydev", group_index = 0},
        {name = "nvim_lsp", max_item_count = 10},
        -- {name = "nvim_lsp_signature_help", max_item_count = 1},
        {name = "buffer", max_item_count = 8, keyword_length = 2},
        {name = "rg", max_item_count = 5, keyword_length = 4},
        -- {name = "git", max_item_count = 5, keyword_length = 2},
        -- {
        --     name = 'rime',
        --     option = {
        --     },
        -- },
        -- {
        --     name = 'rime_punct',
        --     option = {
        --     },
        -- },
        -- {name = "luasnip", max_item_count = 8},
        {name = "path"},
        -- {name = "codeium"}, -- INFO: uncomment this for AI completion
        -- {name = "spell", max_item_count = 4},
		-- {name = "cmp_yanky", max_item_count = 2},
        {name = "calc", max_item_count = 3},
        -- {name = "cmdline"},
        -- {name = "git"},
        -- {name = "emoji", max_item_count = 3},
        -- {name = "copilot"}, -- INFO: uncomment this for AI completion
        -- {name = "cmp_tabnine"}, -- INFO: uncomment this for AI completion
    },

    -- 对补全建议排序
    sorting = {
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            require("cmp-under-comparator").under,
            -- require("cmp_tabnine.compare"), -- INFO: uncomment this for AI completion
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        }
    },


    -- 快捷键
    mapping = {
        -- 上一个
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- 下一个
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        -- 出现补全
        ['<C-j>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        -- 取消
        ['<C-k>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        -- RIME 专用确认
        -- ['<Space>'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.mapping.confirm({
        --             select = true,
        --             behavior = cmp.ConfirmBehavior.Replace,
        --         })
        --     else
        --         fallback()
        --     end
        -- end, { 'i', 's' }),
        -- 确认
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ['<CR>'] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Insert,
        }),

        -- ['<Space>'] = cmp.mapping.confirm({
        --     select = false,
        --     behavior = cmp.ConfirmBehavior.Insert,
        -- }),
        -- ['<C-Space>'] = cmp.mapping.disable,
        -- ['<CR>'] = cmp.mapping({
        --     i = cmp.mapping.abort(),
        --     c = cmp.mapping.close(),
        -- }),

        -- ['1'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.mapping.confirm({
        --             select = true,
        --             behavior = cmp.ConfirmBehavior.Replace,
        --         })
        --     else
        --         fallback()
        --     end
        -- end),
        -- ['2'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ['3'] = cmp.mapping(function(fallback)
        --     if cmp.visible() then
        --         cmp.select_next_item()
        --         cmp.select_next_item()
        --     else
        --         fallback()
        --     end
        -- end, { "i", "s" }),
        -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    },

    -- 使用 lspkind-nvim 显示类型图标
    formatting = {
        format = has_lspkind and lspkind.cmp_format {
            mode = 'symbol',
            maxwidth = 50,
            before = function(entry, vim_item)
                vim_item.menu = "["..string.upper(entry.source.name).."]"

                if entry.source.name == "calc" then
                    vim_item.kind = "Calc"
                end

                if entry.source.name == "git" then
                    vim_item.kind = "Git"
                end

                if entry.source.name == "rg" then
                    vim_item.kind = "Search"
                end

                if entry.source.name == "rime" then
                    vim_item.kind = "Rime"
                end

                if entry.source.name == "cmp_yanky" then
                    vim_item.kind = "Clipboard"
                end

                -- if entry.source.name == "nvim_lsp_signature_help" then
                --     vim_item.kind = "Call"
                -- end

                -- vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
                return vim_item
            end,
            ellipsis_char = '...',
            symbol_map = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "󰠱",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "󰌋",
                Snippet = "",
                Color = "󰏘",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "󰙅",
                Event = "",
                Operator = "󰆕",
                TypeParameter = "",
                Calc = "",
                Git = "",
                Search = "",
                Rime = "",
                Clipboard = "",
                Call = "",
            },
        },
    },
}

-- Use buffer source for `/`.
-- cmp.setup.cmdline({'/', '?'}, {
--     mapping = cmp.mapping.preset.cmdline({
--         -- Use default nvim history scrolling
--         ["<C-n>"] = {
--             c = false,
--         },
--         ["<C-p>"] = {
--             c = false,
--         },
--         ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--         ['<Tab>'] = cmp.mapping.select_next_item(),
--     }),
--     sources = {
--         { name = 'buffer' },
--     }
-- })
--
-- -- -- Use cmdline & path source for ':'.
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline({
--         -- Use default nvim history scrolling
--         ["<C-n>"] = {
--             c = false,
--         },
--         ["<C-p>"] = {
--             c = false,
--         },
--         ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--         ['<Tab>'] = cmp.mapping.select_next_item(),
--     }),
--     sources = cmp.config.sources {
--         { name = 'path' },
--         { name = 'cmdline' },
--     }
-- })

-- vim.opt.spell = true
-- vim.opt.spelllang = { 'en_us' }

-- require("tailwindcss-colorizer-cmp").setup({
--     color_square_width = 2,
-- })
