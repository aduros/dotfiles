local function get_alternate_files (file)
  local root, base, ext = string.match(file, '(.*)/src/(.+)%.(.+)')
  if base then
    return root .. '/test/' .. base .. '.test.' .. ext
  end

  root, base, ext = string.match(file, '(.*)/test/(.+)%.test%.(.+)')
  if base then
    return root .. '/src/' .. base .. '.' .. ext
  end
end

local function load_alternate_file (split_mode)
  local file = vim.api.nvim_buf_get_name(0)
  if file then
    local alternate_file = get_alternate_files(file)
    if alternate_file then
      local command = split_mode and 'vsplit' or 'edit'
      vim.cmd(command .. ' ' .. alternate_file)
    end
  end
end

-- Swap between source and test file
vim.keymap.set('n', '<leader>te', function ()
  load_alternate_file(false)
end)
vim.keymap.set('n', '<leader>tE', function ()
  load_alternate_file(true)
end)

vim.diagnostic.config({
  signs = false,
  severity_sort = true,
})
