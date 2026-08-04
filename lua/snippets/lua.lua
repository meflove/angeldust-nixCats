---@diagnostic disable: undefined-global
-- LuaSnip snippets for the `lua` filetype.
--
-- This file is loaded by the LuaSnip *lua-loader* (see :h luasnip-loaders-lua).
-- Because of that, the snippet constructors used below — s, sn, t, i, f, c, d,
-- r, rep, p, l, m, fmt, fmta, parse, … — are injected as globals and do NOT
-- have to be `require`d. The `---@diagnostic disable` line above silences the
-- "undefined-global" warnings from lua-language-server for exactly this reason.
--
-- Bodies are written flush-left inside the [[ ]] strings: LuaSnip re-indents the
-- snippet to the cursor position, and the relative indentation (2 spaces here)
-- is preserved as-is.

return {
  -- local function name(args) … end
  s(
    { trig = "lfn", dscr = "local function" },
    fmta(
      [[local function <name>(<args>)
  <body>
end]],
      { name = i(1, "name"), args = i(2), body = i(0) }
    )
  ),

  -- function name(args) … end
  s(
    { trig = "fn", dscr = "global function" },
    fmta(
      [[function <name>(<args>)
  <body>
end]],
      { name = i(1, "name"), args = i(2), body = i(0) }
    )
  ),

  -- local module = require("module") — `rep` mirrors tab-stop 1 into the string.
  s(
    { trig = "req", dscr = "require with a mirrored local" },
    fmta('local <name> = require("<mod>")', { name = i(1, "module"), mod = rep(1) })
  ),

  -- if / if-else / if-elseif-else — a `c` (choice) node. Cycle the branch with <C-l>.
  s(
    { trig = "if", dscr = "if statement (cycle else/elseif via <C-l>)" },
    fmta(
      [[if <cond> then
  <body>
<tail>]],
      {
        cond = i(1, "cond"),
        body = i(2),
        tail = c(3, {
          t("end"),
          fmta(
            [[else
  <else_body>
end]],
            { else_body = i(1) }
          ),
          fmta(
            [[elseif <elif_cond> then
  <elif_body>
end]],
            { elif_cond = i(1, "cond"), elif_body = i(2) }
          ),
        }),
      }
    )
  ),

  -- for k, v in pairs(t) do … end
  s(
    { trig = "forp", dscr = "for-in-pairs" },
    fmta(
      [[for <k>, <v> in pairs(<tbl>) do
  <body>
end]],
      { k = i(1, "k"), v = i(2, "v"), tbl = i(3, "t"), body = i(0) }
    )
  ),

  -- for i, v in ipairs(t) do … end
  s(
    { trig = "fori", dscr = "for-in-ipairs" },
    fmta(
      [[for <idx>, <val> in ipairs(<tbl>) do
  <body>
end]],
      { idx = i(1, "i"), val = i(2, "v"), tbl = i(3, "t"), body = i(0) }
    )
  ),

  -- local ok, res = pcall(fn)
  s(
    { trig = "pc", dscr = "pcall" },
    fmta("local <ok>, <res> = pcall(<fn>)", { ok = i(1, "ok"), res = i(2, "res"), fn = i(3, "fn") })
  ),

  -- debug print: type a variable name once; it appears in the label and the call.
  s(
    { trig = "pr", dscr = "debug print with vim.inspect" },
    fmta('print("<name>:", vim.inspect(<val>))', { name = i(1, "var"), val = rep(1) })
  ),

  -- dynamic node demo: type on line 1, line 2 mirrors it UPPERCASED.
  -- `d` rebuilds its nodes from the text of tab-stop 1 as you edit it
  -- (needs update_events = "TextChanged,TextChangedI", set in completion.lua).
  s({ trig = "up", dscr = "dynamic node: mirror tab 1 uppercased" }, {
    i(1, "text"),
    t({ "", "-- upper: " }),
    d(2, function(args)
      return sn(nil, i(1, string.upper(args[1][1])))
    end, { 1 }),
  }),
}
