require "stitcher"
using Stitcher::Refinements::Type

# Object to Type.
# Type is Class object.
1.type         # => Fixnum Type
"homu".type    # => String Type
Numeric.type   # => Numeric Type


# Operator is like Class object operators.
1.type == Fixnum   # => true
1.type == Numeric  # => false
1.type <= Numeric  # => true


# Using | operator.
# Example: Define Boolean type
Boolean = TrueClass | FalseClass

Boolean == true   # => true
Boolean == false  # => true
Boolean == nil    # => false
Boolean == 0      # => false
