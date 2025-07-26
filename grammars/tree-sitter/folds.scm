; Simple folds.
([
  (interface)
  (program)
  (subroutine)
  (function)
  (do_loop_statement)
  (select_case_statement)
] @fold
  (#set! fold.adjustToEndOfPreviousRow))

; Divided folds.
(derived_type_statement) @fold.start
"contains" @fold.end @fold.start
(end_type_statement) @fold.end

(module_statement) @fold.start
(end_module_statement) @fold.end

(if_statement "then" @fold.start)
[
  (else_clause)
  (elseif_clause)
] @fold.end @fold.start
(end_if_statement) @fold.end
