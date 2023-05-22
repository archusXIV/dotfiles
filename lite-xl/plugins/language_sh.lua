-- mod-version:3
local syntax = require "core.syntax"

syntax.add {
  name = "Shell script",
  files = { "%.sh$", "%.bash$", "^%.bashrc$", "^%.bash_profile$", "^%.profile$" },
  headers = "^#!.*bin.*sh\n",
  comment = "#",
  patterns = {
    -- $# is a bash special variable and the '#' shouldn't be interpreted
    -- as a comment.
    { pattern = "$[%a_@*#][%w_]*",                type = "keyword2" },
    -- Comments
    { pattern = "#.*\n",                          type = "comment"  },
    -- Strings
    { pattern = { '"', '"', '\\' },               type = "string"   },
    { pattern = { "'", "'", '\\' },               type = "string"   },
    { pattern = { '`', '`', '\\' },               type = "string"   },
    -- Ignore numbers that start with dots or slashes
    { pattern = "%f[%w_%.%/]%d[%d%.]*%f[^%w_%.]", type = "number"   },
    -- Operators
    { pattern = "[!<>|&%[%]:=*]",                 type = "operator" },
    -- Match parameters
    { pattern = "%f[%S][%+%-][%w%-_:]+",          type = "function" },
    { pattern = "%f[%S][%+%-][%w%-_]+%f[=]",      type = "function" },
    -- Prevent parameters with assignments from been matched as variables
    {
      pattern = "%s%-%a[%w_%-]*%s+()%d[%d%.]+",
      type = { "function", "number" }
    },
    {
      pattern = "%s%-%a[%w_%-]*%s+()%a[%a%-_:=]+",
      type = { "function", "symbol" }
    },
    -- Match variable assignments
    { pattern = "[_%a][%w_]+%f[%+=]",              type = "keyword2" },
    -- Match variable expansions
    { pattern = "${.-}",                           type = "keyword2" },
    { pattern = "$[%d$%a_@*][%w_]*",               type = "keyword2" },
    -- Functions
    { pattern = "[%a_%-][%w_%-]*[%s]*%f[(]",       type = "function" },
    -- Everything else
    { pattern = "[%a_][%w_]*",                     type = "symbol"   },
  },
  symbols = {
    ["alias"]     = "literal",
    ["awk"]       = "string3",
    ["break"]     = "literal",
    ["case"]      = "keyword",
    ["cat"]       = "string3",
    ["continue"]  = "literal",
    ["cut"]       = "string3",
    ["declare"]   = "literal",
    ["disown"]    = "literal",
    ["do"]        = "keyword",
    ["done"]      = "keyword",
    ["echo"]      = "literal",
    ["elif"]      = "keyword",
    ["else"]      = "keyword",
    ["enable"]    = "keyword",
    ["esac"]      = "keyword",
    ["eval"]      = "literal",
    ["exec"]      = "literal",
    ["export"]    = "literal",
    ["exit"]      = "literal",
    ["false"]     = "literal",
    ["fi"]        = "keyword",
    ["find"]      = "string3",
    ["for"]       = "keyword",
    ["function"]  = "keyword",
    ["getopts"]   = "literal",
    ["grep"]      = "string3",
    ["hash"]      = "literal",
    ["head"]      = "string3",
    ["if"]        = "keyword",
    ["in"]        = "keyword",
    ["let"]       = "literal",
    ["local"]     = "literal",
    ["mapfile"]   = "literal",
    ["paste"]     = "string3",
    ["pidof"]     = "string3",
    ["pgrep"]     = "string3",
    ["printf"]    = "literal",
    ["read"]      = "literal",
    ["readarray"] = "literal",
    ["return"]    = "literal",
    ["sed"]       = "string3",
    ["select"]    = "keyword",
    ["set"]       = "literal",
    ["shift"]     = "literal",
    ["shopt"]     = "literal",
    ["sort"]      = "string3",
    ["source"]    = "literal",
    ["tail"]      = "string3",
    ["then"]      = "keyword",
    ["time"]      = "keyword",
    ["tr"]        = "string3",
    ["trap"]      = "literal",
    ["true"]      = "literal",
    ["unalias"]   = "literal",
    ["uniq"]      = "string3",
    ["unset"]     = "literal",
    ["until"]     = "keyword",
    ["wait"]      = "literal",
    ["wc"]        = "string3",
    ["while"]     = "keyword",
  },
}
