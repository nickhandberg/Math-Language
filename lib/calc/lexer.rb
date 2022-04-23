require 'strscan'        # require String Scanner
require 'calc/token'     #require calc/token classes

module Calc
  # A class that takes lines of source code and creates an ordered array of Calc::Token .
  class Lexer

    # Converts the string value to a real number.
    def self.convert_to_literal(str)
      if /(\+|\-)?\d+\.\d+/ =~ str    #if the input value is a String
        str.to_f                      #convert String to a fload
      else
        str.to_i                      #conver String to integer
      end
    end

    # Takes the input lines of source code and produces an array of Calc::Token
    def self.lex(input)   #lexer get input line of source code
      tokens = []         #create token input array

      Calc::invalid_syntax("",0, "Input must respond to #each_line") unless input.respond_to?(:each_line)# function message for error syntax

      definitions_done = false
      input.each_line do |line|
        source_line = line.strip # Remove leading and trailing spaces

        next if source_line.empty? # Skip empty lines

        Calc::invalid_syntax("",0, "Each line must start with '('") unless source_line.start_with?('(') #
        Calc::invalid_syntax("",0, "Each line must end with ')'") unless source_line.end_with?(')')
        Calc::invalid_syntax("",0, "Syntax contains symbols that are not supported") if /[^\(\)a-zA-Z\d\s\+\-\*\/\.]+/ =~ source_line
        Calc::invalid_syntax("",0, "Definitions must come before the expressions") unless !definitions_done || !/^\(\s*let/.match(source_line)

        if /^\(\s*(?<let>let)\s*(?<identifier>[a-zA-Z][a-zA-Z\d]*)\s*(?<number>(\+|\-)?(\d+\.\d+|\d+))\)$/ =~ source_line
          # We've found a definition, let's create a set of Tokens.
          tokens << Token.new(Token::LET,let,1)
          tokens << Token.new(Token::IDENTIFIER,identifier,5)
          tokens << Token.new(Token::NUMBER, convert_to_literal(number),5 + identifier.length - 1)
        else
          definitions_done = true
          last_pos = 0
          s = StringScanner.new(source_line)
          while (!s.eos?) do
            s.skip(/\(/) # Skip (
            s.skip(/\)/) # Skip )

            # Scan through the string to find a number.
            if number = s.scan(/(\+|\-)?(\d+\.\d+|\d+)/)
              tokens << Token.new(Token::NUMBER,convert_to_literal(number),s.pos)
            end

            # Scan through the string to find an identifier.
            if identifier = s.scan(/[a-zA-Z][a-zA-Z\d]*/)
              tokens << Token.new(Token::IDENTIFIER,identifier,s.pos)
            end

            # Scan through the string to find an operator.
            if operator = s.scan(/\+|\-|\*|\//)
              tokens << Token.new(Token::OPERATOR,operator,s.pos)
            end

            s.skip(/\s+/)
            Calc::invalid_syntax(s.post_match,s.pos, "") if last_pos == s.pos # We didn't scan anything
            last_pos = s.pos
          end
        end
      end
      tokens
    end
  end
end
