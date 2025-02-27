((tag
  (name) @comment.todo @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.todo "TODO" "WIP"))

("text" @comment.todo @nospell
  (#any-of? @comment.todo "TODO" "WIP"))

