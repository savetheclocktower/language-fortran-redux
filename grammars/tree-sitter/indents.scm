(if_statement "if" @indent)
(program_statement "program" @indent)
(subroutine_statement "subroutine" @indent)
(do_loop_statement "do" @indent)
(interface_statement "interface" @indent)
(derived_type_statement "type" @indent)
(module_statement "module" @indent)
(function_statement "function" @indent)
(enum_statement "enum" @indent)

; A `where` statement that isn't a one-liner.
(where_statement "where" @indent
  (#is-not? test.startsOnSameRowAs parent.endPosition))

; A `where` clause when there isn't yet a corresponding `endwhere`.
("where" @indent
  (#is? test.descendantOfType "ERROR"))

[
  "elsewhere"
  "else"
  "elseif"
  "contains"
] @dedent @indent

[
  "end"
  "endif"
  "endprogram"
  "endsubroutine"
  "endfunction"
  "endinterface"
  "endmodule"
  "endsubmodule"
  "endprocedure"
  "endwhere"
] @dedent
