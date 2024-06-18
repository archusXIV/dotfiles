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
    { pattern = { "'", "'", '\\' },               type = "string2"  },
    { pattern = { '`', '`', '\\' },               type = "string3"  },
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
    ["awk"]       = "function",
    ["break"]     = "keyword",
    ["case"]      = "keyword",
    ["cat"]       = "function",
    ["clear"]     = "function",
    ["continue"]  = "keyword",
    ["cp"]        = "function",
    ["cut"]       = "function",
    ["declare"]   = "literal",
    ["disable"]   = "keyword",
    ["disown"]    = "literal",
    ["do"]        = "keyword",
    ["done"]      = "keyword",
    ["echo"]      = "literal",
    ["elif"]      = "keyword",
    ["else"]      = "keyword",
    ["enable"]    = "keyword",
    ["esac"]      = "keyword",
    ["eval"]      = "function",
    ["exec"]      = "literal",
    ["export"]    = "literal",
    ["exit"]      = "literal",
    ["false"]     = "literal",
    ["fi"]        = "keyword",
    ["find"]      = "function",
    ["for"]       = "keyword",
    ["function"]  = "keyword",
    ["getopts"]   = "literal",
    ["grep"]      = "function",
    ["hash"]      = "function",
    ["head"]      = "function",
    ["if"]        = "keyword",
    ["in"]        = "keyword",
    ["let"]       = "literal",
    ["local"]     = "literal",
    ["mapfile"]   = "literal",
    ["mkdir"]     = "literal",
    ["mv"]        = "function",
    ["paste"]     = "function",
    ["pgrep"]     = "function",
    ["pwd"]       = "function",
    ["printf"]    = "function",
    ["read"]      = "function",
    ["readarray"] = "literal",
    ["return"]    = "literal",
    ["rm"]        = "function",
    ["rmdir"]     = "function",
    ["sed"]       = "function",
    ["select"]    = "keyword",
    ["set"]       = "literal",
    ["shift"]     = "literal",
    ["shopt"]     = "literal",
    ["sort"]      = "function",
    ["source"]    = "literal",
    ["tail"]      = "function",
    ["tee"]       = "function",
    ["then"]      = "keyword",
    ["time"]      = "function",
    ["tr"]        = "function",
    ["trap"]      = "literal",
    ["true"]      = "literal",
    ["type"]      = "keyword",
    ["unalias"]   = "literal",
    ["uniq"]      = "function",
    ["unset"]     = "literal",
    ["until"]     = "keyword",
    ["wait"]      = "literal",
    ["wc"]        = "function",
    ["while"]     = "keyword",
  },
}
