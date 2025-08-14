require'nvim-tree'.setup {
    auto_reload_on_write = true,
    hijack_cursor = false,
    -- open_on_setup = false,
    -- open_on_setup_file = true,
    hijack_unnamed_buffer_when_opening = false,
    sort_by = "name",
    view = {
        width = 30,
        -- height = 30,
        side = "right",
        --color = "#3f0af0",
        preserve_window_proportions = true, -- cmake-tools say that they need this
    },
    filters = {
        custom = { "^.git$" },
    },
    renderer = {
        icons = {
            web_devicons = {
                file = {
                    enable = true,
                    color = true,
                },
                folder = {
                    enable = false,
                    color = true,
                },
            },
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
                hidden = false,
                diagnostics = true,
                bookmarks = true,
            },
        },
    },
}

-- vim.cmd [[
-- augroup exit_if_nvim_tree_only_tab
-- autocmd!
-- autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | wqa | endif
-- augroup end
-- ]]

local function open_nvim_tree(data)
  -- -- buffer is a real file on the disk
  -- local real_file = vim.fn.filereadable(data.file) == 1
  --
  -- -- buffer is a [No Name]
  -- local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  -- if not real_file and not no_name and not directory then
  --   return
  -- end

  if not directory then
      -- open the tree, find the file but don't focus it
      -- require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
  else
      -- create a new, empty buffer
      -- vim.cmd.enew()
      -- wipe the directory buffer
      vim.cmd.bw(data.buf)
      -- change to the directory
      vim.cmd.cd(data.file)
      -- open the tree
      require("nvim-tree.api").tree.open()
  end
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

-- vim.api.nvim_create_autocmd("BufEnter", {
--   nested = true,
--   callback = function()
--     if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
--       vim.cmd "quit"
--     end
--   end
-- })

-- local map = require'archvim/mappings'
