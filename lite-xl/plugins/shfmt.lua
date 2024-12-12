-- mod-version:3

-- Automatic formatter for bash scripts
-- Dependencies: `shfmt` command in PATH or whatever formatter is chosen in
-- configuration

-- Run with
--   Shfmt: format

-- Imports
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local common = require "core.common"

-- Config
config.plugins.shfmt = common.merge({
  enabled = true,
  exec = "shfmt",
  args = "-i 4 -w",
  config_spec = {
    name = "Shell Scripts Formatter",
    {
      label = "Formatter command",
      description = "Path to executable.",
      path = "exec",
      type = "string",
      default = "shfmt"
    },
    {
      label = "Formatter arguments",
      description = "Command line arguments.",
      path = "args",
      type = "string",
      default = "-i 4 -w",
    }
  }
}, config.plugins.shfmt)

-- Main logic
local function format()

  -- Save the file if it is unsaved or dirty
  local doc = core.active_view.doc
  if doc:get_name() == "unsaved" or doc:is_dirty() then
    doc:save()
  end

  -- Run command
  local ok, _, code = os.execute(
    string.format(
      "%s %s %s",
      config.plugins.shfmt.exec,
      config.plugins.shfmt.args,
      doc:get_name()
    )
  )

  -- Return with error code if any
  if not ok then
    core.log("Failed to format file, return code is " .. code)
    return
  end

  -- Log success and reload file
  core.log("File is reformatted, reloading document")
  doc:reload()
end

-- Register the command
command.add("core.docview", {["shfmt:format"] = format})

