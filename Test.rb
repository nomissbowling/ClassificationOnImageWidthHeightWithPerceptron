require "active_support"
require "active_support/core_ext"

a = [1, 2, 3]
b = a.deep_dup
b[1] = 333
p a
p b