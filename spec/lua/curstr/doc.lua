local example_path = "./spec/lua/curstr/example.vim"
local util = require("genvdoc.util")

local ok, result = pcall(vim.cmd, "source" .. example_path)
if not ok then
  error(result)
end

require("genvdoc").generate("curstr.nvim", {
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "PARAMETERS",
      body = function(ctx)
        return util.help_tagged(ctx, "Configurations", "curstr.nvim-setup-config") .. [[

- {source_aliases} (table | nil): can define alias names
  - {names} (string[]): source names. curstr try to execute by this order.
  - {filetypes} (string[] | nil): if not nil, this alias is enabled only on the filetypes.
  - {opts} (table | nil): source specific options.

- {sources} (table | nil): can change source settings
  - {filetypes} (string[] | nil)
  - {opts} (table | nil)]]
      end,
    },
    {
      name = "ACTION SOURCES",
      body = function(ctx)
        local sections = {}
        for _, source in ipairs(require("curstr.core.action_source").Source.all()) do
          table.insert(sections, util.help_tagged(ctx, ("`%s`"):format(source.name), "curstr-source-" .. source.name) .. util.indent(source.description, 2) .. "\n")
        end
        return vim.trim(table.concat(sections, "\n"))
      end,
    },
    {
      name = "DEFAULT SOURCE ALIASES",
      body = function()
        local aliases = require("curstr.core.custom").default_config.source_aliases
        local alias_names = vim.tbl_keys(aliases)
        table.sort(alias_names, function(a, b)
          return a < b
        end)

        local sections = {}
        for _, alias_name in ipairs(alias_names) do
          local alias = aliases[alias_name]
          local names = vim.tbl_map(function(name)
            return "- " .. name
          end, alias.names)
          local section = ("`%s` alias to \n"):format(alias_name) .. table.concat(names, "\n") .. "\n"
          table.insert(sections, section)
        end
        return vim.trim(table.concat(sections, "\n"))
      end,
    },
    {
      name = "ACTIONS",
      body = function(ctx)
        local sections = {}
        for _, group in ipairs(require("curstr.core.action_group").ActionGroup.all()) do
          local actions = vim.tbl_map(function(action)
            return "- " .. action
          end, group:actions())
          local section = util.help_tagged(ctx, ("`%s` actions"):format(group.name), "curstr-action-group-" .. group.name) .. table.concat(actions, "\n") .. "\n"
          table.insert(sections, section)
        end
        return vim.trim(table.concat(sections, "\n"))
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path)
      end,
    },
  },
})
