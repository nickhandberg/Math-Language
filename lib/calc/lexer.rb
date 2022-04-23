require 'strscan'        # require String Scanner
require 'calc/token'     #require calc/token classes

module Calc
  # Token class takes the Calc code and generates a meaningful set of tokens that can be parsed
  class Lexer

    # String to literal conversion 
    def self.convert_to_literal(str)
      if /(\+|\-)?\d+\.\d+/ =~ str    #if the input value is a String
        str.to_f                      #convert String to a float
      else
        str.to_i                      #convert String to integer
      end
    end

    # Generates tokens from the Calc code
    def self.lex(input)   #lexer get input line of source code
      tokens = []         #create token input array

      Calc::invalid_syntax("",0, "Input must respond to #each_line") unless input.respond_to?(:each_line)# function message for error syntax

      definitions_done = false
      input.each_line do |line|
        source_line = line.strip

        # Skips the line if empty
        next if source_line.empty?
        
        # Checks for correct syntax in the code. (Checks for parenthesis, unsupported symbols, and late definitions)
        Calc::invalid_syntax("",0, "Each line must start with '('") unless source_line.start_with?('(') #
        Calc::invalid_syntax("",0, "Each line must end with ')'") unless source_line.end_with?(')')
        Calc::invalid_syntax("",0, "Syntax contains symbols that are not supported") if /[^\(\)a-zA-Z\d\s\+\-\*\/\.]+/ =~ source_line
        Calc::invalid_syntax("",0, "Definitions must come before the expressions") unless !definitions_done || !/^\(\s*let/.match(source_line)

        # Checking for definitions (includes LET keyword)
        if /^\(\s*(?<let>let)\s*(?<identifier>[a-zA-Z][a-zA-Z\d]*)\s*(?<number>(\+|\-)?(\d+\.\d+|\d+))\)$/ =~ source_line
          # Creates the tokens for the definition
          tokens << Token.new(Token::LET,let,1)
          tokens << Token.new(Token::IDENTIFIER,identifier,5)
          tokens << Token.new(Token::NUMBER, convert_to_literal(number),5 + identifier.length - 1)

        # Otherwise, definitions are done, so move on to expressions
        else
          definitions_done = true
          last_pos = 0
          s = StringScanner.new(source_line)
          while (!s.eos?) do
            # Ignores the opening/closing parenthesis by skipping
            s.skip(/\(/) 
            s.skip(/\)/) 

            # Finds number by scanning through the string and creates new token for it
            if number = s.scan(/(\+|\-)?(\d+\.\d+|\d+)/)
              tokens << Token.new(Token::NUMBER,convert_to_literal(number),s.pos)
            end

            # Finds identifier by scanning through the string and creates a new token for it
            if identifier = s.scan(/[a-zA-Z][a-zA-Z\d]*/)
              tokens << Token.new(Token::IDENTIFIER,identifier,s.pos)
            end

            # Finds the operator by scanning through the string and creates a new token for it
            if operator = s.scan(/\+|\-|\*|\//)
              tokens << Token.new(Token::OPERATOR,operator,s.pos)
            end

            s.skip(/\s+/)
            Calc::invalid_syntax(s.post_match,s.pos, "") if last_pos == s.pos
            last_pos = s.pos
          end
        end
      end
      tokens
    end
  end
end
