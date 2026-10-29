; Highlight Moo/MooX-style declarations and method modifiers as keywords.
"use" @keyword

((function) @keyword
  (#any-of? @keyword
    "has" "extends" "with" "around" "before" "after"
    "override" "augment" "inner" "super"
    "requires" "consumes" "excludes" "namespace"))

; Moo attribute option keys are auto-quoted barewords; give them a property
; color instead of letting them fall through to the string group.
((autoquoted_bareword) @property
  (#any-of? @property
    "is" "isa" "coerce" "lazy" "builder" "default" "trigger"
    "handles" "reader" "writer" "accessor" "predicate" "clearer"
    "required" "weak_ref" "init_arg" "documentation" "traits"
    "alias" "metaclass" "inline_as" "from" "via" "should"))
