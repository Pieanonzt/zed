; Functions names start with `Test`
(
  [
    (function_declaration name: (_) @run
      (#match? @run "^Test.*"))
    (method_declaration
      receiver: (parameter_list
        (parameter_declaration
          name: (identifier) @_receiver_name
          type: [
            (pointer_type (type_identifier) @_receiver_type)
            (type_identifier) @_receiver_type
          ]
        )
      )
      name: (field_identifier) @run @_method_name
      (#match? @_method_name "^Test.*"))
  ] @_
  (#set! tag go-test)
)

; `go:generate` comments
(
    ((comment) @_comment @run
    (#match? @_comment "^//go:generate"))
    (#set! tag go-generate)
)

; `t.Run`
(
  (
    (call_expression
      function: (
        selector_expression
        field: _ @run @_name
        (#eq? @_name "Run")
      )
      arguments: (
        argument_list
        .
        [
          (interpreted_string_literal)
          (raw_string_literal)
        ] @_subtest_name
        .
        (func_literal
          parameters: (
            parameter_list
            (parameter_declaration
              name: (identifier) @_param_name
              type: (pointer_type
                (qualified_type
                  package: (package_identifier) @_pkg
                  name: (type_identifier) @_type
                  (#eq? @_pkg "testing")
                  (#eq? @_type "T")
                )
              )
            )
          )
        ) @_second_argument
      )
    )
  ) @_
  (#set! tag go-subtest)
)

; Functions names start with `Benchmark`
(
  (
    (function_declaration name: (_) @run @_name
      (#match? @_name "^Benchmark.*"))
  ) @_
  (#set! tag go-benchmark)
)

; Functions names start with `Fuzz`
(
  (
    (function_declaration name: (_) @run @_name
      (#match? @_name "^Fuzz"))
  ) @_
  (#set! tag go-fuzz)
)

; go run
(
  (
    (function_declaration name: (_) @run
      (#eq? @run "main"))
  ) @_
  (#set! tag go-main)
)
