-- mod-version:3
--[[
  foldblocks plugin for lite-xl 2.1. By archusXIV.
  Install: copy to USERDIR/plugins/foldblocks.lua  (e.g. ~/.config/lite-xl/plugins/)
  This plugin enables code folding/unfolding mechanism in the opened files in lite-xl,
  using keywords as blocks openers/closers that determine boundaries for candidate
  blocks for folding/unfolding mechanism. Characters (), {}, [] also act the same way.
--]]

local core      = require "core"
local command   = require "core.command"
local common    = require "core.common"
local config    = require "core.config"
local keymap    = require "core.keymap"
local style     = require "core.style"
local translate = require "core.doc.translate"
local Doc       = require "core.doc"
local DocView   = require "core.docview"

-- kept separately so options still fall back to sane defaults even if the
-- user replaces config.plugins.foldblocks with a table missing some fields
local DEFAULTS = {
  min_lines    = 2,
  gutter       = true,
  indicators   = true,
  mode         = "auto",   -- "auto" | "indent" | "tokens" | "markers"
  marker_open  = "{{{",
  marker_close = "}}}",
  -- open/closed gutter marks: a 2-char string ("+-", "▸▾") or a table
  -- of two strings for multi-character marks, e.g. { "<>", "< >" };
  -- the keys indicator_open / indicator_close also work and override this
  indicator_symbols = "+-",
}

local function opt(name)
  local v = config.plugins.foldblocks[name]
  if v == nil then return DEFAULTS[name] end
  return v
end

local WITH_SPEC = common.merge(DEFAULTS, {
  config_spec  = {
    name = "Fold Blocks",
    {
      label = "Minimum lines",
      description = "Smallest block that can be folded.",
      path = "min_lines",
      type = "number",
      min = 2,
      max = 20,
      step = 1,
    },
    {
      label = "Show gutter marks",
      path = "gutter",
      type = "toggle",
    },
    {
      label = "Show fold indicators",
      path = "indicators",
      type = "toggle",
    },
    {
      label = "Detection mode",
      path = "mode",
      type = "selection",
      values = {
        { "Auto", "auto" },
        { "Indent", "indent" },
        { "Tokens", "tokens" },
        { "Markers {{{ }}}", "markers" },
      },
    },
    {
      label = "Indicator symbols",
      description = "Marks for the folded/unfolded gutter, e.g. +- (init.lua also accepts a table like { \"<>\", \"< >\" })",
      path = "indicator_symbols",
      type = "string",
    },
  },
})
config.plugins.foldblocks = common.merge(WITH_SPEC, config.plugins.foldblocks)

-- token pairs scanned by fold_by_tokens. `then` is omitted on purpose:
-- Lua `elseif ... then` would otherwise nest incorrectly.
local PAIRS = {
  { "{", "}" },
  { "[", "]" },
  { "(", ")" },
  { "function", "end" },
  { "do", "end" },
  { "repeat", "until" },
}

-- per-document state, keyed weakly so closed docs GC
local docs = setmetatable({}, { __mode = "k" })

local function state(doc)
  local s = docs[doc]
  if not s then
    s = { ranges = {} }
    docs[doc] = s
  end
  return s
end

local function invalidate(s)
  s.vis_of = nil
  s.doc_of = nil
  s.rows = nil
  s.hidden = nil
  s.next_visible = nil
  s.extent = nil
  s.headers = nil
end

-- visual-row cache: hidden lines share the header's row and have height 0
local function rebuild(doc)

  local s = state(doc)
  local n = #doc.lines
  local hidden, headers = {}, {}
  for _, r in ipairs(s.ranges) do
    local a, b = r[1], r[2]
    if a < 1 then a = 1 end
    if b > n then b = n end
    if b > a then
      headers[a] = b
      for i = a + 1, b do hidden[i] = true end
    end
  end

  local vis_of, doc_of = {}, {}
  local row = 0
  for i = 1, n do
    if not hidden[i] then
      row = row + 1
      vis_of[i] = row
      doc_of[row] = i
    else
      vis_of[i] = math.max(row, 1)
    end
  end

  local next_visible, nxt = {}, n + 1
  for i = n, 1, -1 do
    next_visible[i] = nxt
    if not hidden[i] then nxt = i end
  end

  s.hidden = hidden
  s.headers = headers
  s.vis_of = vis_of
  s.doc_of = doc_of
  s.rows = math.max(row, 1)
  s.next_visible = next_visible

end

local function ensure(doc)
  local s = state(doc)
  if not s.vis_of then rebuild(doc) end
  return s
end

local function line_hidden(doc, line)
  return ensure(doc).hidden[line] == true
end

local function header_is_folded(doc, line)
  return ensure(doc).headers[line] ~= nil
end

-- detectors --------------------------------------------------------------
local function indent_of(text)
  local ws = text:match("^[ \t]*")
  return ws and #ws or 0
end

--[[
  Keywords which can actually introduce an indentation-based block.
  This is intentionally much narrower than `typ == "keyword"`: treating
  every keyword as a block header is what made one-line statements such as
  `while ... do ... end` susceptible to the indentation fallback.
--]]
local BLOCK_OPENERS = {
  -- Lua / Bash / Vimscript / similar
  ["case"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true, ["elif"] = true,
  ["for"] = true, ["function"] = true, ["if"] = true, ["local function"] = true,
  ["repeat"] = true, ["select"] = true, ["until"] = true, ["while"] = true,
  -- A few common explicit block forms
  ["catch"] = true, ["class"] = true, ["finally"] = true,
  ["module"] = true, ["namespace"] = true, ["try"] = true,
  -- Ruby / Perl / Pascal / Delphi / Fortran / VB(Script) style openers
  ["begin"] = true, ["def"] = true, ["unless"] = true, ["sub"] = true,
  ["with"] = true, ["interface"] = true, ["struct"] = true, ["enum"] = true,
  ["program"] = true, ["procedure"] = true, ["record"] = true,
}

--[[
  generic closers used by many keyword-block languages (bash, lua, vimscript,
  ruby, pascal, vb, fortran,...); catches one-liners like
  `while x do y end` / `if x; then y; fi` so they aren't mistaken for an
  open block header.

  Note: some words (e.g. "until") are openers in one language (bash) and
  closers in another (lua's `repeat ... until`). header_tokens() below
  resolves that ambiguity positionally rather than by table membership.
--]]
local BLOCK_CLOSERS = {
  ["done"] = true, ["end"] = true, ["endif"] = true, ["esac"] = true,
  ["endfor"] = true, ["endwhile"] = true, ["endfunction"] = true,
  ["fi"] = true, ["until"] = true,
  -- Ruby / Pascal / Delphi / Fortran / VB(Script) style closers
  ["wend"] = true, ["endcase"] = true, ["endinterface"] = true,
  ["endstruct"] = true, ["endenum"] = true, ["endprogram"] = true,
  ["endprocedure"] = true, ["endrecord"] = true, ["endwith"] = true,
}

--[[
  ask the buffer's own syntax highlighter whether the line opens a block,
  instead of matching against a fixed, language-specific keyword list.
--]]
local function header_tokens(doc, header)
  local first_type, first_token, second_token, closed
  local token_index = 0

  --[[
    Use the syntax highlighter for token boundaries. In particular, do not
    use a plain string search here: an `end` inside a comment or string must
    not make a real block look closed.
  --]]
  for _, typ, text in doc.highlighter:each_token(header) do
    if typ ~= "comment" and typ ~= "string" then
      local token = text and text:match("^%s*(.-)%s*$") or ""
      if token ~= "" then
        token_index = token_index + 1
        if not first_type then
          first_type = typ
          first_token = token:lower()
        elseif not second_token then
          second_token = token:lower()
        end
        --[[
          Skip the closer check on the header's own first token: words
          such as "until" are an opener in one language (bash `until
          cond; do`) and a closer in another (lua `repeat ... until`), so
          matching it against itself would wrongly mark the header closed.
        --]]
        if token_index > 1 and BLOCK_CLOSERS[token:lower()] then
          closed = true
        end
      end
    end
  end

  --[[
    Lua's `local function name()` is a block opener too.
    The highlighter normally gives `local` and `function`
    as separate tokens, so combine the first two significant tokens for the opener lookup.
    --]]
  if first_token and second_token and
     first_token == "local" and second_token == "function" then
    first_token = "local function"
  end

  --[[
    Some highlighters return a whole expression as one token.
    When that happens, the token loop above can miss an inline closer.
    For a line whose first token is a known block keyword,
    use a conservative raw-text fallback.
    This specifically protects constructs such as:
      while condition do work() end
      if condition then work() end
    The fallback is only used for recognized block keywords, so ordinary
    keyword statements are not accidentally turned into folds.
  --]]
  if not closed and first_token and BLOCK_OPENERS[first_token] then
    local code = (doc.lines[header] or ""):lower()
    -- strip the leading opener keyword itself so it can't be re-matched
    -- as its own closer (see the "until" note on BLOCK_CLOSERS above)
    local rest = code:match("^%s*" .. first_token:gsub("%s+", "%%s+") .. "%f[^%w_](.*)$") or code
    for closer in pairs(BLOCK_CLOSERS) do
      if rest:match("%f[%w_]" .. closer .. "%f[^%w_]") then
        closed = true
        break
      end
    end
  end

  return first_type, first_token, closed
end

local function fold_by_indent(doc, header)

  local lines = doc.lines
  local n = #lines
  local head = lines[header]

  if not head or head:match("^%s*$") then return nil end

  local first_type, first_token, closed = header_tokens(doc, header)
  if closed then return nil end

  local structural = head:match("[%:{]%s*$") or (first_type == "keyword" and first_token and BLOCK_OPENERS[first_token])
  if not structural then return nil end

  local base = indent_of(head)
  local i = header + 1

  --[[
    this one-liner while loop folding indicator appears because we're reviewing
    the plugin file using lite-xl itself while the plugin is active,
    and the test that turns off indicators is way down below @line 572
  --]]
  while i <= n and lines[i]:match("^%s*$") do i = i + 1 end

  if i > n or indent_of(lines[i]) <= base then return nil end

  local last = i
  for j = i, n do
    if not lines[j]:match("^%s*$") and indent_of(lines[j]) <= base then
      break
    end
    last = j
  end

  if last - header < opt("min_lines") then return nil end
  return header, last

end

local function fold_by_tokens(doc, header)

  local stack, saw = {}, false
  local min_lines = opt("min_lines")
  local last = math.min(#doc.lines, header + 8000)

  for line = header, last do
    for _, typ, text in doc.highlighter:each_token(line) do
      if typ ~= "comment" and typ ~= "string" then
        for pi = 1, #PAIRS do
          local p = PAIRS[pi]
          if text == p[1] then
            stack[#stack + 1] = pi
            saw = true
            break
          elseif text == p[2] then
            if #stack > 0 and PAIRS[stack[#stack]][2] == text then
              stack[#stack] = nil
            end
            break
          end
        end
      end
    end

    if line == header and not saw then return nil end

    if saw and #stack == 0 then
      if line - header >= min_lines then return header, line end
      return nil
    end

  end
  return nil

end

local function fold_by_markers(doc, header)

  local open  = opt("marker_open")
  local close = opt("marker_close")
  local head = doc.lines[header]

  if not head or not head:find(open, 1, true) then return nil end

  local depth = 1
  for i = header + 1, #doc.lines do

    local l = doc.lines[i]
    local from = 1
    while true do

      local a = l:find(open, from, true)
      local b = l:find(close, from, true)

      if not a and not b then break end
      if a and (not b or a < b) then
        depth = depth + 1
        from = a + #open
      else

        depth = depth - 1
        from = b + #close
        if depth == 0 then
          if i - header >= opt("min_lines") then
            return header, i
          end
          return nil
        end

      end

    end

  end
  return nil

end

local function detect_fold(doc, header)

  local mode = opt("mode")
  if mode == "markers" or mode == "auto" then
    local a, b = fold_by_markers(doc, header)
    if a then return a, b end
    if mode == "markers" then return nil end
  end

  if mode == "tokens" or mode == "auto" then
    local a, b = fold_by_tokens(doc, header)
    if a then return a, b end
    if mode == "tokens" then return nil end
  end

  if mode == "indent" or mode == "auto" then
    return fold_by_indent(doc, header)
  end

end

local function fold_extent(doc, header)

  local s = state(doc)
  s.extent = s.extent or {}
  if s.extent[header] == nil then
    local _, e = detect_fold(doc, header)
    s.extent[header] = e or false
  end

  return s.extent[header] or nil

end

local function is_foldable(doc, line)
  return header_is_folded(doc, line) or fold_extent(doc, line) ~= nil
end

-- range edits ------------------------------------------------------------
local function add_range(doc, a, b)

  if b < a then a, b = b, a end
  if b - a < opt("min_lines") then return end

  local s = state(doc)
  local out = {}
  for _, r in ipairs(s.ranges) do
    if not (r[1] == a and r[2] == b) then
      out[#out + 1] = r
    end
  end

  out[#out + 1] = { a, b }
  table.sort(out, function(x, y) return x[1] < y[1] end)
  s.ranges = out
  invalidate(s)

end

local function remove_range(doc, a)
  local s = state(doc)
  local out = {}
  for _, r in ipairs(s.ranges) do
    if r[1] ~= a then out[#out + 1] = r end
  end
  s.ranges = out
  invalidate(s)
end

local function toggle_fold(doc, line, force)

  if header_is_folded(doc, line) then
    if force == true then return end
    remove_range(doc, line)
    core.redraw = true
    return
  end

  if force == false then
    local s = ensure(doc)
    if s.hidden[line] then
      for _, r in ipairs(s.ranges) do
        if line > r[1] and line <= r[2] then
          remove_range(doc, r[1])
          break
        end
      end
    end
    core.redraw = true
    return
  end

  local e = fold_extent(doc, line)
  if e then add_range(doc, line, e) end
  core.redraw = true

end

local function fold_all(doc)
  local n = #doc.lines
  for i = n, 1, -1 do
    if not header_is_folded(doc, i) then
      local e = fold_extent(doc, i)
      if e then add_range(doc, i, e) end
    end
  end
  core.redraw = true
end

local function unfold_all(doc)
  local s = state(doc)
  s.ranges = {}
  invalidate(s)
  core.redraw = true
end

--[[
  at   = first affected document line (1-based)
  diff = net line delta (>0 insert, <0 delete)
  when diff < 0, deleted original lines are [at, at - diff]
--]]
local function shift_ranges(doc, at, diff)

  if diff == 0 then return end
  local s = state(doc)
  local out = {}
  local del_end = diff < 0 and (at - diff) or nil
  local min_lines = opt("min_lines")

  for _, r in ipairs(s.ranges) do

    local a, b = r[1], r[2]
    if diff > 0 then
      if at < a then
        a, b = a + diff, b + diff
      elseif at <= b then
        b = b + diff
      end

    else

      local function map(line)
        if line < at then return line end
        if line <= del_end then return at end
        return line + diff
      end
      a, b = map(a), map(b)
    end

    if b - a >= min_lines then
      out[#out + 1] = { a, b }
    end

  end

  s.ranges = out
  invalidate(s)
end

-- Doc hooks --------------------------------------------------------------
local raw_insert = Doc.raw_insert
function Doc:raw_insert(line, col, text, ...)
  raw_insert(self, line, col, text, ...)
  local n = 0
  for _ in text:gmatch("\n") do n = n + 1 end
  if n ~= 0 then
    shift_ranges(self, line, n)
  else
    state(self).extent = nil
  end
end

local raw_remove = Doc.raw_remove
function Doc:raw_remove(line1, col1, line2, col2, ...)
  raw_remove(self, line1, col1, line2, col2, ...)
  local diff = line1 - line2
  if diff ~= 0 then
    shift_ranges(self, line1, diff)
  else
    state(self).extent = nil
  end
end

-- DocView remaps ---------------------------------------------------------
local function wrapping(dv)
  return dv.wrapped_settings ~= nil
end

local function indicator_symbols()
  local sym = opt("indicator_symbols")
  local open, close
  if type(sym) == "table" then
    -- multi-character marks, e.g. { "<>", "< >" }
    open  = sym[1] or ""
    close = sym[2] or ""
  else
    sym = tostring(sym)
    open  = sym:sub(1, 1)
    close = sym:sub(2, 2)
  end
  -- individual keys override indicator_symbols when set,
  -- e.g. config.plugins.foldblocks.indicator_open = "<>"
  open  = opt("indicator_open")  or open
  close = opt("indicator_close") or close
  if open == "" then open = "+" end
  if close == "" then close = "-" end
  return open, close
end

local function fold_col_width(dv)
  if opt("gutter") == false or opt("indicators") == false then
    return 0
  end
  local open, close = indicator_symbols()
  local font = dv:get_font()
  return math.max(font:get_width(open), font:get_width(close)) + style.padding.x
end

local old_gutter_width = DocView.get_gutter_width
function DocView:get_gutter_width()
  local w, pad = old_gutter_width(self)
  return w + fold_col_width(self), pad
end

function DocView:draw_fold_gutter(line, x, y, width)
  local fw = fold_col_width(self)
  if fw <= 0 then return 0 end

  local folded = header_is_folded(self.doc, line)
  if folded or fold_extent(self.doc, line) then
    local open, close = indicator_symbols()
    local mark = folded and open or close
    common.draw_text(self:get_font(), style.accent, mark, "center", x, y, fw, self:get_line_height())
  end
  return fw
end

local old_gutter = DocView.draw_line_gutter
function DocView:draw_line_gutter(line, x, y, width)

  if line_hidden(self.doc, line) then return 0 end
  local lh = self:get_line_height()
  local fw = fold_col_width(self)

  self:draw_fold_gutter(line, x, y, fw)

  return old_gutter(self, line, x + fw, y, math.max(0, width - fw)) or lh

end

local old_body = DocView.draw_line_body
function DocView:draw_line_body(line, x, y)

  if line_hidden(self.doc, line) then return 0 end

  local h = old_body(self, line, x, y) or self:get_line_height()
  if header_is_folded(self.doc, line) then
    local tw = self:get_col_x_offset(line, #self.doc.lines[line])
    common.draw_text(self:get_font(), style.dim, " …", "left",
      x + tw, y, 80, self:get_line_height())
  end
  return h

end

local old_pos = DocView.get_line_screen_position
function DocView:get_line_screen_position(line, col)

  if wrapping(self) or #state(self.doc).ranges == 0 then
    return old_pos(self, line, col)
  end

  local s = ensure(self.doc)
  local vis = s.vis_of[line] or line
  local x, y = self:get_content_offset()
  local lh = self:get_line_height()
  local gw = self:get_gutter_width()
  y = y + (vis - 1) * lh + style.padding.y
  if col then
    return x + gw + self:get_col_x_offset(line, col), y
  end
  return x + gw, y

end

local old_resolve = DocView.resolve_screen_position
function DocView:resolve_screen_position(x, y)

  if wrapping(self) or #state(self.doc).ranges == 0 then
    return old_resolve(self, x, y)
  end

  local s = ensure(self.doc)
  local first = s.doc_of[1] or 1
  local _, oy = self:get_line_screen_position(first)
  local row = common.clamp(
    math.floor((y - oy) / self:get_line_height()) + 1,
    1, s.rows)
  local line = s.doc_of[row] or first
  local ox = select(1, self:get_line_screen_position(line))
  return line, self:get_x_offset_col(line, x - ox)

end

local old_size = DocView.get_scrollable_size
function DocView:get_scrollable_size()

  if wrapping(self) or #state(self.doc).ranges == 0 then
    return old_size(self)
  end

  local s = ensure(self.doc)
  if not config.scroll_past_end then
    return self:get_line_height() * s.rows + style.padding.y * 2
  end

  return self:get_line_height() * (s.rows - 1) + self.size.y

end

local old_visible = DocView.get_visible_line_range
function DocView:get_visible_line_range()

  if wrapping(self) or #state(self.doc).ranges == 0 then
    return old_visible(self)
  end

  local s = ensure(self.doc)
  local _, y, _, y2 = self:get_content_bounds()
  local lh = self:get_line_height()
  local minrow = math.max(1, math.floor((y - style.padding.y) / lh) + 1)
  local maxrow = math.min(s.rows, math.floor((y2 - style.padding.y) / lh) + 1)
  minrow = math.min(minrow, s.rows)
  maxrow = math.max(maxrow, minrow)
  return s.doc_of[minrow] or 1, s.doc_of[maxrow] or #self.doc.lines

end

local old_draw = DocView.draw
function DocView:draw()

  if wrapping(self) or #state(self.doc).ranges == 0 then
    return old_draw(self)
  end

  local s = ensure(self.doc)
  self:draw_background(style.background)
  local _, indent_size = self.doc:get_indent_info()
  self:get_font():set_tab_size(indent_size)

  local minline, maxline = self:get_visible_line_range()
  local lh = self:get_line_height()
  local gw, gpad = self:get_gutter_width()
  local gutter_w = gpad and gw - gpad or gw

  local function each_visible(fn)
    local _, y = self:get_line_screen_position(minline)
    local i = minline
    while i <= maxline do
      if s.hidden[i] then
        i = s.next_visible[i]
        if not i or i > maxline + 1 then break end
      else
        y = y + (fn(i, y) or lh)
        i = i + 1
      end
    end
  end

  each_visible(function(i, y)
    return self:draw_line_gutter(i, self.position.x, y, gutter_w)
  end)

  local pos = self.position
  local x = select(1, self:get_line_screen_position(minline))
  core.push_clip_rect(pos.x + gw, pos.y, self.size.x - gw, self.size.y)
  each_visible(function(i, y)
    return self:draw_line_body(i, x, y)
  end)
  self:draw_overlay()
  core.pop_clip_rect()
  self:draw_scrollbar()

end

local old_press = DocView.on_mouse_pressed
function DocView:on_mouse_pressed(button, x, y, clicks)

  if button == "left" and opt("gutter") ~= false then

    local fw = fold_col_width(self)
    if fw > 0 and x >= self.position.x and x < self.position.x + fw then
      local line = self:resolve_screen_position(x, y)
      if line and is_foldable(self.doc, line) then
        toggle_fold(self.doc, line)
        return true
      end
    end

  end
  return old_press(self, button, x, y, clicks)

end

local old_update = DocView.update
function DocView:update()

  old_update(self)
  local doc = self.doc
  if not doc or #state(doc).ranges == 0 then return end
  local line = doc:get_selection()
  if line_hidden(doc, line) then

    local s = ensure(doc)
    local best
    for _, r in ipairs(s.ranges) do
      if line > r[1] and line <= r[2] then
        if not best or r[1] > best[1] then best = r end
      end
    end

    if best then remove_range(doc, best[1]) end

  end

end

local old_next = translate.next_line
function translate.next_line(doc, line, col, dv)
  local l, c = old_next(doc, line, col, dv)
  local s = ensure(doc)
  while s.hidden and s.hidden[l] and l < #doc.lines do
    l = l + 1
  end
  return doc:sanitize_position(l, c)
end

local old_prev = translate.previous_line
function translate.previous_line(doc, line, col, dv)
  local l, c = old_prev(doc, line, col, dv)
  local s = ensure(doc)
  while s.hidden and s.hidden[l] and l > 1 do
    l = l - 1
  end
  return doc:sanitize_position(l, c)
end

-- commands ---------------------------------------------------------------
local function active_docview()
  local dv = core.active_view
  if dv and dv.doc then return dv end
end

local function command_for(fn)
  return function()
    local dv = active_docview()
    if dv then fn(dv.doc) end
  end
end

command.add("core.docview", {
  ["foldblocks:toggle"] = command_for(function(doc)
    toggle_fold(doc, doc:get_selection())
  end),
  ["foldblocks:fold"] = command_for(function(doc)
    toggle_fold(doc, doc:get_selection(), true)
  end),
  ["foldblocks:unfold"] = command_for(function(doc)
    toggle_fold(doc, doc:get_selection(), false)
  end),
  ["foldblocks:fold-all"] = command_for(fold_all),
  ["foldblocks:unfold-all"] = command_for(unfold_all),
  ["foldblocks:fold-selection"] = command_for(function(doc)
    local l1, _, l2 = doc:get_selection(true)
    add_range(doc, l1, l2)
    core.redraw = true
  end),
})

keymap.add {
  ["ctrl+alt+f"] = "foldblocks:fold",
  ["ctrl+alt+u"] = "foldblocks:unfold",
  ["ctrl+alt+t"] = "foldblocks:toggle",
  ["ctrl+alt+a"] = "foldblocks:fold-all",
  ["ctrl+alt+g"] = "foldblocks:unfold-all",
  ["ctrl+alt+s"] = "foldblocks:fold-selection",
}
