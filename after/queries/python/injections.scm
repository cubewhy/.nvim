; extends

(call
  function: (identifier) @_func_name (#any-of? @_func_name "eval" "exec")
  arguments: (argument_list
    (string
      (string_content) @injection.content))
  (#set! injection.language "python")
)
