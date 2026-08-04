---@diagnostic disable: undefined-global
-- LuaSnip snippets for the `python` filetype.
--
-- Loaded by the LuaSnip *lua-loader* (see :h luasnip-loaders-lua); the snippet
-- constructors are injected as globals, so no `require` is needed.
-- Uses `fmta` (<> delimiters) so Python's own `{}` (dicts, sets, f-strings)
-- never collide with placeholders.

return {
  -- def name(args): …
  s(
    { trig = "def", dscr = "function definition" },
    fmta(
      [[def <name>(<args>):
    <body>]],
      { name = i(1, "name"), args = i(2), body = i(0) }
    )
  ),

  -- def name(self, …): …   (method)
  s(
    { trig = "defm", dscr = "method definition" },
    fmta(
      [[def <name>(self<args>):
    <body>]],
      { name = i(1, "name"), args = i(2), body = i(0) }
    )
  ),

  -- def __init__(self, args): …
  s(
    { trig = "init", dscr = "constructor" },
    fmta(
      [[def __init__(self, <args>):
    <body>]],
      { args = i(1), body = i(0) }
    )
  ),

  -- class Name(Base): … — `base` is a choice node (no base / (Base)).
  s(
    { trig = "class", dscr = "class definition" },
    fmta(
      [[class <name><base>:
    <body>]],
      {
        name = i(1, "Name"),
        base = c(2, {
          t(""),
          sn(nil, { t("("), i(1, "Base"), t(")") }),
        }),
        body = i(0),
      }
    )
  ),

  -- if __name__ == "__main__": …
  s(
    { trig = "ifmain", dscr = 'if __name__ == "__main__"' },
    fmta(
      [[if __name__ == "__main__":
    <main>]],
      { main = i(0, "main()") }
    )
  ),

  -- @dataclass\nclass Name: …
  s(
    { trig = "dataclass", dscr = "dataclass" },
    fmta(
      [[@dataclass
class <name>:
    <field>]],
      { name = i(1, "Name"), field = i(0, "field: type") }
    )
  ),

  -- try / except
  s(
    { trig = "try", dscr = "try/except" },
    fmta(
      [[try:
    <try_body>
except <exc> as <e>:
    <except_body>]],
      { try_body = i(1), exc = i(2, "Exception"), e = i(3, "e"), except_body = i(0) }
    )
  ),

  -- with expr as name: …
  s(
    { trig = "with", dscr = "with statement" },
    fmta(
      [[with <expr> as <name>:
    <body>]],
      { expr = i(1, "open(...)"), name = i(2, "f"), body = i(0) }
    )
  ),

  -- breakpoint()
  s({ trig = "pdb", dscr = "breakpoint()" }, t("breakpoint()")),

  -- print(f"{var=}")  — prints "var=<value>"
  s({ trig = "pf", dscr = 'debug f-print "var="' }, fmta('print(f"{<name>=}")', { name = i(1, "var") })),
}
