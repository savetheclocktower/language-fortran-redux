
(program_statement (name) @name) @definition.program

(subroutine_statement (name)
  @name) @definition.function

(module_statement (name)
  @name) @definition.module

(statement_label) @definition.label @name

(function_statement name: (name) @name) @definition.function

(interface_statement (name) @name) @definition.interface

(derived_type_statement (type_name) @name) @definition.type
