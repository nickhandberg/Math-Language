module Calc
    # Class that defines the set of tokens useful in the Calc program
    class Token
        # Defines the token types
        LET = 0
        IDENTIFIER = 1
        NUMBER = 2
        OPERATOR = 3

        # getter/setter functionality
        attr_accessor :type,:value,:column

        # Class constructor method creates Token instance
        def initialize(type, value, column)
            @type = type
            @value = value
            @column = column
        end
    end
end``