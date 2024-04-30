--
-- Big thanks to @akinsho, since most of this was copied and inspired from akinsho/flutter-tools.
--
local util = require('go.utils')
local log = util.log

local has_telescope, telescope = pcall(require, "telescope")

if not has_telescope then
  local msg = "Telescope must be installed to use this functionality (https://github.com/nvim-telescope/telescope.nvim)"
  log(msg)
end
-- Load necessary dependencies
local go_commands = require("go.commands_telescope")

local function go_commands_picker(opts)
  opts = opts or require("telescope.themes").get_dropdown({
    previewer = false,
  })

  require("telescope.pickers").new(opts, {
    prompt_title = "Go Commands",
    finder = require("telescope.finders").new_table({
      results = go_commands.generate_telescope_commands(),
      entry_maker = function(entry)
        return {
          value = entry.command,
          display = entry.label,
          ordinal = entry.label .. " " .. entry.desc,
        }
      end
    }),
    sorter = require("telescope.config").values.generic_sorter(opts),
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local selection = require("telescope.actions.state").get_selected_entry(bufnr)
        require("telescope.actions").close(bufnr)
        if selection then
          selection.value()  -- Execute the command function.
        end
      end)
      map("n", "<CR>", function(bufnr)
        local selection = require("telescope.actions.state").get_selected_entry(bufnr)
        require("telescope.actions").close(bufnr)
        if selection then
          selection.value()  -- Execute the command function.
        end
      end)
      return true
    end,
  }):find()
end

return require("telescope").register_extension({
  exports = {
    go_commands = go_commands_picker,
  },
})
