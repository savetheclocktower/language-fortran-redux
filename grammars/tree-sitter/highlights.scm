
; PREPROCESSOR
; ============

[
  "#if"
  "#ifdef"
  "#ifndef"
  "#endif"
  "#elif"
  "#else"
] @keyword.control.directive.conditional.fortran

"#define" @keyword.control.directive.define.fortran
"#include" @keyword.control.directive.include.fortran

(["#if" "#ifdef" "#ifndef" "#endif" "#elif" "#else" "#define" "#include"] @punctuation.definition.directive.fortran
  (#set! adjust.endAfterFirstMatchOf "^#"))

; `preproc_directive` will be used when the parser doesn't recognize the
; directive as one of the above. It's permissive; `#afdfafsdfdfad` would be
; parsed as a `preproc_directive`.
;
; Hence this rule will match if the more specific rules above haven't matched.
; The anonymous nodes will match under ideal conditions, but might not be
; present even when they ought to be _if_ the parser is flummoxed; so this'll
; sometimes catch `#ifdef` and others.
((preproc_directive) @keyword.control.directive.fortran
  (#set! capture.shy true))

((preproc_directive) @punctuation.definition.directive.fortran
  (#set! capture.shy true)
  (#set! adjust.endAfterFirstMatchOf "^#"))

; Macro functions are definitely entities.
(preproc_function_def
  (identifier) @entity.name.function.preprocessor.fortran
  (#set! capture.final true))

; Identifiers in macro definitions are definitely constants.
((preproc_def
  name: (identifier) @constant.preprocessor.fortran))

; We can also safely treat identifiers as constants in `#ifdef`…
((preproc_ifdef
  (identifier) @constant.preprocessor.fortran))

; …and `#if` and `#elif`…
(preproc_if
  (binary_expression
    (identifier) @constant.preprocessor.fortran))
(preproc_elif
  (binary_expression
    (identifier) @constant.preprocessor.fortran))

; …and `#undef`.
((preproc_call
  directive: (preproc_directive) @_IGNORE_
  argument: (preproc_arg) @constant.preprocessor.fortran)
  (#eq? @_IGNORE_ "#undef"))

(preproc_params "..." @keyword.operator.ellipsis.fortran)

(preproc_params
  (identifier) @variable.parameter.preprocessor.fortran)

(system_lib_string) @string.quoted.other.lt-gt.include.fortran
((system_lib_string) @punctuation.definition.string.begin.fortran
  (#set! adjust.endAfterFirstMatchOf "^<"))
((system_lib_string) @punctuation.definition.string.end.fortran
  (#set! adjust.startBeforeFirstMatchOf ">$"))



; COMMENTS
; ========

(comment) @comment.line.exclamation.fortran
(preproc_comment) @comment.block.preprocessor.fortran

; VALUES
; ======

; Booleans
; --------

((boolean_literal) @constant.language.boolean.fortran
  (#set! adjust.endAt firstChild.endPosition))

(boolean_literal kind: (identifier) @support.storage.type.kind.fortran)

; Numbers
; -------

(number_literal) @constant.numeric.fortran

; Strings
; -------

; Strings can be marked with "kinds.""
(string_literal kind: (identifier) @support.storage.type.kind.fortran)

; Single-quoted string without a kind annotation.
((string_literal) @string.quoted.single.fortran
  (#match? @string.quoted.single.fortran "^'"))

((string_literal) @punctuation.definition.string.begin.fortran
  (#match? @punctuation.definition.string.begin.fortran "^'")
  (#set! adjust.endAfterFirstMatchOf "^'"))

((string_literal) @punctuation.definition.string.end.fortran
  (#match? @punctuation.definition.string.end.fortran "'$")
  (#set! adjust.startBeforeFirstMatchOf "'$"))

; Double-quoted string without a kind annotation.
((string_literal) @string.quoted.double.fortran
  (#match? @string.quoted.double.fortran "^\""))

((string_literal) @punctuation.definition.string.begin.fortran
  (#match? @punctuation.definition.string.begin.fortran "^\"")
  (#set! adjust.endAfterFirstMatchOf "^\""))

((string_literal) @punctuation.definition.string.end.fortran
  (#match? @punctuation.definition.string.end.fortran "\"$")
  (#set! adjust.startBeforeFirstMatchOf "\"$"))

; Single-quoted string with a kind annotation.
((string_literal) @string.quoted.single.with-kind.fortran
 (#match? @string.quoted.single.with-kind.fortran "^[\\w\\d]+_'")
  (#set! adjust.startAfterFirstMatchOf "^[\\w\\d]+_(?=')"))

((string_literal) @punctuation.definition.string.begin.fortran
  (#match? @punctuation.definition.string.begin.fortran "^[\\w\\d]+_'")
  (#set! adjust.endAfterFirstMatchOf "^[\\w\\d]+_'"))

; Double-quoted string with a kind annotation.
((string_literal) @string.quoted.double.with-kind.fortran
 (#match? @string.quoted.double.with-kind.fortran "^[\\w\\d]+_\"")
  (#set! adjust.startAfterFirstMatchOf "^[\\w\\d]+_(?=\")"))

((string_literal) @punctuation.definition.string.begin.fortran
  (#match? @punctuation.definition.string.begin.fortran "^[\\w\\d]+_\"")
  (#set! adjust.endAfterFirstMatchOf "^[\\w\\d]+_\""))

; `include` argument can only be a string, without any interpolations or
; dynamic content. So let's treat it like one.

(include_statement path: (filename) @string.quoted.single.fortran
  (#match? @string.quoted.single.fortran "^'"))
(include_statement path: (filename) @string.quoted.double.fortran
  (#match? @string.quoted.double.fortran "^\""))

(include_statement path: (filename)
  @punctuation.definition.string.begin.fortran
  (#set! adjust.endAfterFirstMatchOf "^(?:'|\")"))
(include_statement path: (filename)
  @punctuation.definition.string.end.fortran
  (#set! adjust.startBeforeFirstMatchOf "(?:'|\")$"))

; Common blocks are a form of string literal.
;
; Sadly, sometimes they're delimited with slashes and sometimes they aren't.
; And the slashes aren't part of the node; they flank the node. No easy way to
; deal with that, or to style the slashes as string delmiters.
(common_block) @string.quoted.other.common-block.fortran


; TYPES
; =====

(derived_type_definition
  (derived_type_statement
    (type_name) @entity.name.type.definition.fortran)
    (#set! capture.final))

(type_name) @support.storage.type.fortran

((intrinsic_type) @support.storage.type.builtin.fortran
  (#set! adjust.endAt firstChild.endPosition))

(procedure_attributes "attributes" @support.storage.modifier.attributes.fortran)

(derived_type "type" @support.storage.type.fortran)

[
  "device"
  "global"
  "grid_global"
  "host"
  "import"
] @storage.type._TYPE_.fortran

[
  "abstract"
  "allocatable"
  "asynchronous"
  "automatic"
  "codimension"
  "dimension"
  "constant"
  "contiguous"
  "device"
  "external"
  "intrinsic"
  "non_intrinsic"
  "managed"
  "optional"
  "parameter"
  "pinned"
  "pointer"
  "rank"
  "save"
  "sequence"
  "shared"
  "static"
  "target"
  "texture"
  "value"
  "volatile"
  "result"
] @storage.modifier._TEXT_.fortran

; Procedure qualifiers.
([
  "elemental"
  "impure"
  "pure"
  "recursive"
  "simple"
] @storage.modifier.procedure._TEXT_.fortran
  (#set! capture.final))

(procedure_qualifier) @storage.modifier.procedure._TEXT_.fortran

[
  "generic"
  "initial"
  "procedure"
  "property"
  "final"
] @storage.modifier.procedure.binding._TEXT_.fortran

; STORAGE
; =======

(public_statement "public" @storage.modifier.public.fortran)

(private_statement "private" @storage.modifier.private.fortran)

(public_statement (identifier) @keyword.other.special-method.fortran)
(private_statement (identifier) @keyword.other.special-method.fortran)
(method_name) @keyword.other.special-method.fortran

(procedure_statement
  (method_name) @keyword.other.special-method.fortran)

((type_qualifier) @storage.modifier._TEXT_.fortran
  (#match? @storage.modifier._TEXT_.fortran "^([a-z])$")
  (#set! capture.final))

; Match type qualifiers like `intent(in)`, but only the `intent` part.
((type_qualifier) @storage.modifier.fortran
  (#set! adjust.endBeforeFirstMatchOf "\\("))


; VARIABLES
; =========

(binding_name (identifier) @variable.other.binding.fortran)

(variable_declaration
  declarator: (identifier) @variable.other.declaration.fortran)

(variable_declaration
  declarator: (init_declarator
    left: (identifier) @variable.other.assignment.fortran))

(assignment_statement
  left: (identifier) @variable.other.assignment.fortran)

(parameters
  (identifier) @variable.parameter.fortran)

(parameter_assignment (identifier) @variable.parameter.assignment.fortran)

(keyword_argument
  name: (identifier) @variable.parameter.argument.keyword.fortran)

(loop_control_expression
  (identifier) @variable.other.assignment.loop.fortran)

(function_result (identifier) @variable.other.assignment.result.fortran)

; ENTITIES
; ========

(program_statement (name) @entity.name.type.program.fortran)


(module_name) @constant.other.module-name.fortran
(none) @entity.other.attribute-name.fortran

(interface_statement (name) @entity.name.type.interface.fortran)

(statement_label) @entity.name.label.fortran

(function_statement name: (name) @entity.name.function.fortran)

(subroutine_statement (name)
  @entity.name.type.subroutine.fortran)

(module_statement (name)
  @entity.name.type.module.fortran)

(module_procedure_statement (name) @entity.name.type.module-procedure.fortran)

(end_program_statement
  (name) @entity.name.type.program.end.fortran)

(end_module_statement
  (name) @entity.name.type.module.end.fortran)

(end_submodule_statement
  (name) @entity.name.type.submodule.end.fortran)

(end_function_statement
  (name) @entity.name.function.end.fortran)

(end_subroutine_statement
  (name) @entity.name.type.subroutine.end.fortran)

(end_module_procedure_statement
  (name) @entity.name.type.module-procedure.end.fortran)


; SUPPORT
; =======

[
  "exit"
] @support.function._TEXT_.fortran

(open_statement "open" @support.function.open.fortran)
(read_statement "read" @support.function.read.fortran)
(write_statement "write" @support.function.write.fortran)
(format_statement "format" @support.function.format.fortran)
(equivalence_statement "equivalence" @support.function.equivalence.fortran)
(language_binding "bind" @support.function.bind.fortran)

(call_expression (identifier) @support.function._TEXT_.fortran
  (#match? @support.function._TEXT_.fortran "^(trim|char|int|selected_char_kind)$"))

(subroutine_call
  subroutine: (identifier) @support.function.subroutine-call.fortran)

(call_expression (identifier) @support.other.function.call.fortran)


; KEYWORDS
; ========

[
  "end"
  "endprocedure"
  "endprogram"
  "endsubmodule"
  "endsubroutine"
  "enum"
  "enumerator"
  "program"
  "use"
  "implicit"
  "if"
  "endif"
  "where"
  "elsewhere"
  "endwhere"
  "then"
  "else"
  "elseif"
  "call"
  "contains"
  "subroutine"
  "include"
  "interface"
  "module"
  "do"
  "enddo"
  "goto"
  "namelist"
  "operator"
  "stop"
  "submodule"
  "forall"
  "while"
  "select"
  "case"
  (default)
] @keyword.control._TYPE_.fortran

["function" "module"] @storage.type._TYPE_.fortran @keyword.control._TYPE_.fortran

(derived_type_statement "type" @keyword.control.type.fortran)
(derived_type_member_expression
  (type_member) @entity.other.attribute-name.fortran)

; OPERATORS
; =========

[
  "="
] @keyword.operator.assignment.fortran


["//"] @keyword.operator.concatenation.fortran

[
  "=="
  "/="
  "<"
  "<="
  ">"
  ">="
] @keyword.operator.comparison.fortran

(math_expression
  ["*" "+" "/" "-"] @keyword.operator.arithmetic.fortran)

[
  "\\.eq\\."
  "\\.ne\\."
  "\\.lt\\."
  "\\.le\\."
  "\\.gt\\."
  "\\.ge\\."
] @keyword.operator.comparison.text.fortran

[
  "\\.and\\."
  "\\.or\\."
  "\\.not\\."
  "\\.eqv\\."
  "\\.neqv\\."
] @keyword.operator.logical.fortran

(extent_specifier ":" @keyword.operator.range.fortran)
"%" @keyword.operator.accessor.fortran

(unary_expression
  ["-"] @keyword.operator.unary.fortran)

; Edit descriptors are weird. How should we classify them?

; `*` gets operator-like highlighting for visibility.
((edit_descriptor) @keyword.operator.edit-descriptor.fortran
  (#eq? @keyword.operator.edit-descriptor.fortran "*"))

; Other descriptors are inscrutable like regexes, so let's color them like
; constants.
((edit_descriptor) @constant.other.edit-descriptor.fortran
  (#not-eq? @constant.other.edit-descriptor.fortran "*"))

(assumed_size "*" @keyword.operator.assumed-size.fortran)
(operator_name) @keyword.operator.fortran
[
  "<<<"
  ">>>"
] @keyword.operator.kernel-execution.fortran

"&" @keyword.operator.line-continuation.fortran


; MISC
; ====

[
  (unit_identifier "*")
  (format_identifier "*")
] @variable.language.default-unit-or-format-identifier.fortran


; `intent` can be used to mark variables as read-only, write-only, or
; read-write.
(
  (type_qualifier
    [
      "in"
      "out"
      "inout"
    ] @constant.language.type-qualifier.intent.fortran
  )
)

; PUNCTUATION
; ===========

(parameters "(" @punctuation.definition.parameters.begin.bracket.round.fortran
  (#set! capture.final))
(parameters ")" @punctuation.definition.parameters.end.bracket.round.fortran
  (#set! capture.final))

"(" @punctuation.definition.begin.bracket.round.fortran
")" @punctuation.definition.end.bracket.round.fortran

"[" @punctuation.definition.begin.bracket.square.fortran
"]" @punctuation.definition.end.bracket.square.fortran

"," @punctuation.separator.comma.fortran

; TODO: This is technically punctuation, not an operator… but it feels a bit
; strange not to highlight this.
"::" @punctuation.separator.declaration.fortran

"%" @punctuation.separator.percent-sign.fortran
