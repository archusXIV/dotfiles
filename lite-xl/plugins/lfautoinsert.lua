-- mod-version:2 -- lite-xl 2.0
local core = require "core"
local command = require "core.command"
local common = require "core.common"
local config = require "core.config"
local keymap = require "core.keymap"

config.plugins.lfautoinsert = { map = {
  ["{%s*\n"] = "}",
  ["%(%s*\n"] = ")",
  ["%f[[]%[%s*\n"] = "]",
  ["=%s*\n"] = false,
  [":%s*\n"] = false,
  ["->%s*\n"] = false,
  ["%f[%w]in%s*\n"] = "esac",
  ["%f[%w]do%s*\n"] = "done",
  ["%f[%w]then%s*\n"] = "fi",
  ["%f[%w]else%s*\n"] = "fi",
  ["^%s*<([^/][^%s>]*)[^>]*>%s*\n"] = "</$TEXT>",
  ["^%s*{{#([^/][^%s}]*)[^}]*}}%s*\n"] = "{{/$TEXT}}",
  ["/%*%s*\n"] = "*/",
  ["c/c++"] = {
    file_patterns = {
      "%.c$", "%.h$", "%.inl$", "%.cpp$", "%.hpp$",
      "%.cc$", "%.C$", "%.cxx$", "%.c++$", "%.hh$",
      "%.H$", "%.hxx$", "%.h++$"
    },
    map = {
      ["^#if.*\n"] = "#endif",
      ["^#else.*\n"] = "#endif",
    }
  },
  ["lua"] = {
    file_patterns = { "%.lua$" },
    map = {
      ["%f[%w]do%s*\n"] = "end",
      ["%f[%w]then%s*\n"] = "end",
      ["%f[%w]else%s*\n"] = "end",
      ["%f[%w]repeat%s*\n"] = "until",
      ["%f[%w]function.*%)%s*\n"] = "end",
      ["%[%[%s*\n"] = "]]"
    }
  },
} }

local function get_autoinsert_map(filename)
  local map = {}
  for pattern, closing in pairs(config.plugins.lfautoinsert.map) do
    if type(closing) == "table" then
      if common.match_pattern(filename, closing.file_patterns) then
        for p, e in pairs(closing.map) do
          map[p] = e
        end
      end
    else
      map[pattern] = closing
    end
  end

  return map
end


local function indent_size(doc, line)
  local text = doc.lines[line] or ""
  local s, e = text:find("^[\t ]*")
  return e - s
end

command.add("core.docview", {
  ["autoinsert:newline"] = function()
    command.perform("doc:newline")

    local doc = core.active_view.doc
    local line, col = doc:get_selection()
    local text = doc.lines[line - 1]

    for ptn, close in pairs(get_autoinsert_map(doc.filename)) do
      local s, _, str = text:find(ptn)
      if s then
        if  close
        and col == #doc.lines[line]
        and indent_size(doc, line + 1) <= indent_size(doc, line - 1)
        then
          close = str and close:gsub("$TEXT", str) or close
          command.perform("doc:newline")
          core.active_view:on_text_input(close)
          command.perform("doc:move-to-previous-line")
          if doc.lines[line+1] == doc.lines[line+2] then
            doc:remove(line+1, 1, line+2, 1)
          end
        elseif col < #doc.lines[line] then
          command.perform("doc:newline")
          command.perform("doc:move-to-previous-line")
        end
        command.perform("doc:indent")
      end
    end
  end
})

keymap.add {
  ["return"] = { "command:submit", "autoinsert:newline" }
}

return {
  add = function(file_patterns, map)
    table.insert(
      config.plugins.lfautoinsert.map,
      { file_patterns = file_patterns, map=map }
    )
  end
}

