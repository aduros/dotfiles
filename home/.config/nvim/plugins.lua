return {

  'b0o/SchemaStore.nvim',
  -- 'folke/neodev.nvim',
  {
    'neovim/nvim-lspconfig',
    config = function ()
      local lspconfig = require('lspconfig')
      local servers = {
        -- Web dev
        'tsserver', 'html', 'cssls', 'volar', 'eslint',
        -- Systems dev
        'gopls', 'zls',
        -- Other
        'sumneko_lua', 'bashls', 'yamlls', 'jsonls',
      }

      -- FIXME(2022-12-30): Causes weird error about luassert
      -- require("neodev").setup()

      -- Config file schemas for json/yaml
      local schemas = require('schemastore').json.schemas()

      for _, server in ipairs(servers) do
        lspconfig[server].setup {
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
          settings = {
            json = {
              schemas = schemas,
              validate = { enable = true }
            },
            yaml = {
              schemas = schemas,
              -- customTags = {
              --   "!fn",
              --   "!And",
              --   "!And sequence",
              --   "!If",
              --   "!If sequence",
              --   "!Not",
              --   "!Not sequence",
              --   "!Equals",
              --   "!Equals sequence",
              --   "!Or",
              --   "!Or sequence",
              --   "!FindInMap",
              --   "!FindInMap sequence",
              --   "!Base64",
              --   "!Join",
              --   "!Join sequence",
              --   "!Cidr",
              --   "!Ref",
              --   "!Sub",
              --   "!Sub sequence",
              --   "!GetAtt",
              --   "!GetAZs",
              --   "!ImportValue",
              --   "!ImportValue sequence",
              --   "!Select",
              --   "!Select sequence",
              --   "!Split",
              --   "!Split sequence"
              -- }
            }
          },
          on_attach = function (client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

            local opts = { noremap=true, silent=true }
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jD', '<cmd>vsplit | lua vim.lsp.buf.definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jT', '<cmd>vsplit | lua vim.lsp.buf.type_definition()<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jf', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jj', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'jh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'j-', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'j_', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

            vim.api.nvim_buf_set_keymap(bufnr, 'n', 'je', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
          end,
        }
      end

      -- Run eslint on file modification
      -- vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
      --   pattern = '*.tsx,*.ts,*.jsx,*.js,*.mjs,*.vue,*.svelte',
      --   command = 'silent! EslintFixAll',
      -- })

    end
  },

  'tpope/vim-commentary',
  'wellle/targets.vim',
  -- 'skywind3000/asyncrun.vim',

  -- Auto detect indentation settings
  'tpope/vim-sleuth',

  -- Minimal tab completion
  -- TODO(2022-12-28): Replace with nvim-cmp?
  -- 'ajh17/VimCompletesMe',

  {
    'hrsh7th/nvim-cmp',
    -- event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
    },
    config = function ()
      require('luasnip.loaders.from_vscode').lazy_load()

      local cmp = require('cmp')
      local luasnip = require('luasnip')

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        completion = {
          autocomplete = false,
          -- completeopt = "menu,menuone,noinsert",
          -- completeopt = "menu,menuone",
        },
        snippet = {
          expand = function (args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-t>'] = cmp.mapping.scroll_docs(-4),
          ['<C-n>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete(),
          -- ['<C-i>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              -- cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
              -- they way you will only jump inside the snippet region
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete({ reason = cmp.ContextReason.Auto })
              cmp.select_next_item()
              -- cmp.complete({ reason = 'manual'})
              -- cmp.select_next_item({ behavior = 'insert' })
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        }),
      })
    end,
  },

  -- 'hrsh7th/cmp-nvim-lsp',
  -- 'hrsh7th/cmp-buffer',
  -- {
  --   'hrsh7th/nvim-cmp',
  --   setup = function ()
  --     local cmp = require('cmp')
  --     cmp.setup({
  --       snippet = {
  --         expand = function (args)
  --           print("Uhh")
  --         end,
  --       },
  --       sources = cmp.config.sources({
  --         { name = 'nvim_lsp' },
  --       }, {
  --         { name = 'buffer' },
  --       })
  --     })
  --     vim.api.nvim_set_option('completeopt', 'menu,menuone,noselect')
  --   end
  -- },

  -- Color scheme
  'arcticicestudio/nord-vim',
  'machakann/vim-highlightedyank',

  -- Basic new file templating
  'thinca/vim-template',

  -- Indent-aware pasting
  'sickill/vim-pasta',

  -- Rg integration
  'jremmen/vim-ripgrep',

  -- {
  --   'nvim-lualine/lualine.nvim',
  --   config = function ()
  --     require('lualine').setup({
  --       options = {
  --         theme = '16color'
  --       }
  --     })
  --   end
  -- },

  -- Git integration
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup()
    end
  },
  -- {
  --   'TimUntersberger/neogit',
  --   config = function ()
  --     require('neogit').setup({
  --       kind = 'vsplit',
  --       disable_insert_on_commit = false,
  --       disable_commit_confirmation = true,
  --       mappings = {
  --         status = {
  --           ['a'] = 'Stage',
  --           ['s'] = '',
  --         }
  --       }
  --     })
  --   end
  -- },

  -- LF integration
  'akinsho/toggleterm.nvim',
  -- 'nvim-lua/plenary.nvim',
  {
    'lmburns/lf.nvim',
    config = function ()
      vim.g.lf_netrw = 1
      require('lf').setup({
        border = 'curved',
        winblend = 0,
        default_actions = {
          ['<C-s>'] = 'vsplit'
        },
      })
      vim.keymap.set('n', '<C-o>', function () require('lf').start() end)
    end
  },

  'VebbNix/lf-vim', -- lfrc syntax highlighting

  -- FZF integration
  'junegunn/fzf',
  'junegunn/fzf.vim',

  -- Makes the quickfix window modifiable for easy search and replace
  'stefandtw/quickfix-reflector.vim',

  -- Prose
  'godlygeek/tabular',
  'preservim/vim-markdown',
  'preservim/vim-pencil',
  'dkarter/bullets.vim',

  -- Edit binary files with xxd with vim -b <file> or :Hexmode
  'fidian/hexmode',

  'ziglang/zig.vim',

  { dir = '~/local/ai.vim' },

  'windwp/nvim-ts-autotag',
  'JoosepAlviste/nvim-ts-context-commentstring',
  {
    'nvim-treesitter/nvim-treesitter',
    config = function ()
      require('nvim-treesitter.configs').setup({
        -- Messed up in some file types (HTML) and doesn't seem to support TODO highlighting
        -- Maybe selectively enable it for certain filetypes
        -- highlight = {
        --     enable = true,
        -- },
        context_commentstring = {
          enable = true,
        },
        -- Breaks jsdoc comment indentation
        -- indent = {
        --     enable = true,
        -- },
        autotag = {
          enable = true,
        },
      })
    end
  },

  -- 'cohama/lexima.vim',
  {
    'windwp/nvim-autopairs',
    config = function ()
      local npairs = require('nvim-autopairs')
      local Rule = require('nvim-autopairs.rule')
      npairs.setup()
      npairs.add_rules(require('nvim-autopairs.rules.endwise-lua'))
      npairs.add_rule(Rule('/** ', ' */', '-text'))
      -- npairs.add_rule(Rule('/**', '<CR>/<Esc><Up>', '-text')
      -- npairs.add_rule(Rule('/**', '*/', '-text')
        -- :only_cr())
        -- :replace_endpair(function () return '<CR>/<Esc>Ohi<Esc>A' end))
      -- npairs.add_rule(Rule('/**', '<CR>/<Esc>Ohi<Esc>', '-text')
      --   :end_wise()
      --   )
    end
  },

  {
    'mfussenegger/nvim-dap',
    config = function ()
      local dap = require("dap")
      -- for _, language in ipairs({ "typescript", "javascript" }) do
      --   dap.configurations[language] = {
      --       -- {
      --           -- name = "Attach to process",
      --           -- type = "node2",
      --           -- request = "attach",
      --           -- processId = require("dap.utils").pick_process,
      --           -- sourceMaps = true,
      --       -- }
      --       -- {
      --           -- name = "Attach to process",
      --           -- type = "pwa-node",
      --           -- request = "attach",
      --           -- processId = require("dap.utils").pick_process,
      --           -- cwd = "${workspaceFolder}",
      --           -- sourceMaps = true,
      --       -- }
      --       {
      --           type = "pwa-node",
      --           request = "launch",
      --           name = "Debug Jest Tests",
      --           -- trace = true, -- include debugger info
      --           runtimeExecutable = "node",
      --           runtimeArgs = {
      --               "./node_modules/jest/bin/jest.js",
      --               "--runInBand",
      --           },
      --           rootPath = "${workspaceFolder}",
      --           cwd = "${workspaceFolder}",
      --           console = "integratedTerminal",
      --           internalConsoleOptions = "neverOpen",
      --           sourceMaps = true,
      --       }
      --   }
      -- end
    end
  },
  {
    'mxsdev/nvim-dap-vscode-js',
    config = function ()
      require('dap-vscode-js').setup {
        node_path = 'node',
        debugger_path = os.getenv('HOME') .. '/private/apps/vscode-js-debug',
      }
    end
  },

  'nvim-lua/plenary.nvim',
  'haydenmeade/neotest-jest',
  {
    'nvim-neotest/neotest',
    config = function ()
      require('neotest').setup {
        adapters = {
          require('neotest-jest'),
        },
        icons = {
          failed = '✘',
          passed = '✔',
          running = '●',
          skipped = ' ',
          unknown = '·',
        },
        output = {
          open_on_run = false,
        },
        -- quickfix = {
        --   enabled = true,
        --   open = true,
        -- },
        summary = {
          open = 'vsplit',
          mappings = {
            attach = 'a',
            clear_marked = 'M',
            clear_target = {},
            debug = 'd',
            debug_marked = 'D',
            expand = {},
            expand_all = 'e',
            jumpto = '<CR>',
            mark = 'm',
            next_failed = {},
            output = 'O',
            prev_failed = {},
            run = 'r',
            run_marked = 'R',
            short = 'o',
            stop = 'q',
            target = {},
          },
        },
      }
    end
  },

  {
    'nat-418/boole.nvim',
    config = function ()
      require('boole').setup({
        mappings = {
          increment = '<C-=>',
          decrement = '<C-->',
        }
      })
    end
  }
}
