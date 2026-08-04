---@diagnostic disable: undefined-global
-- LuaSnip snippets for the `nix` filetype.
--
-- Loaded by the LuaSnip *lua-loader* (see :h luasnip-loaders-lua); the snippet
-- constructors are injected as globals, so no `require` is needed.
-- Uses `parse` (LSP/snippet-string syntax: $1, ${2:default}, $0) because Nix's
-- own use of {}, <> and [] would otherwise collide with `fmt`/`fmta` delimiters.

return {
  -- let .. = ..; in ..;
  parse(
    { trig = "letin", dscr = "let .. in .." },
    [[let
  ${1:name} = ${2:value};
in
  $0]]
  ),

  -- { lib, pkgs, ... }: <body>
  parse(
    { trig = "fn", dscr = "nix function header" },
    [[{ ${1:lib}, ${2:pkgs}, ... }:
$0]]
  ),

  -- stdenv.mkDerivation { … }
  parse(
    { trig = "mkder", dscr = "mkDerivation" },
    [[stdenv.mkDerivation {
  pname = "${1:name}";
  version = "${2:0.1.0}";

  src = ${3:./.};

  buildInputs = [ $0 ];
}]]
  ),

  -- pkgs.writeShellApplication { … }
  parse(
    { trig = "wsha", dscr = "writeShellApplication" },
    [[pkgs.writeShellApplication {
  name = "${1:script}";
  runtimeInputs = [ ${2:} ];
  text = ''
    ${0:# script body}
  '';
}]]
  ),

  -- <type>.mkOption { … }
  parse(
    { trig = "mkoption", dscr = "mkOption" },
    [[${1:type}.mkOption {
  description = ${2:"..."};
  default = ${3};
};]]
  ),

  -- pkgs.mkShell { … }
  parse(
    { trig = "shell", dscr = "mkShell" },
    [[pkgs.mkShell {
  buildInputs = with pkgs; [
    $0
  ];
}]]
  ),

  -- flake-parts module. Uses `fmt` with `[]` delimiters (not `parse`) because the
  -- Nix attr-name interpolation `${baseNameOf ./.}` would otherwise be read as a
  -- placeholder by the LSP/snippet parser. With `[]` delimiters, every `{}`, `${}`
  -- in the body is literal and only `[type]` / `[body]` are placeholders.
  s(
    { trig = "fpm", dscr = "flake-parts module (nixos)" },
    fmt(
      [[{
  flake = _: {
    [type].${baseNameOf ./.} = {pkgs, ...}: {
      [body]
    };
  };
}]],
      {
        type = c(1, { t("nixosModules"), t("homeModules") }),
        body = i(0, "# module config"),
      },
      { delimiters = "[]" }
    )
  ),
}
