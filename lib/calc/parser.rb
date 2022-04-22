require 'calc/token'
require 'calc/ast'

module Calc
  # Creates AST by crawling through the tokens and creating expressions
  class Parser

    # Parses through the tokens creating definitions and the AST
    def self.parse(tokens)
      # Array to store definitions
      definitions = []
      # Creates new Program instance
      program = AST::Program.new 
      # Creates new Expression using program
      top_expression = AST::Expression.new(program) 
      program.expression = top_expression

      current = nil
      tokens.each do |t|
        case t.type      
        when Token::LET
          # Create new definition if none exist, otherwise throws error
          if current.nil?
            # Changes the context to a definition
            current = AST::Definition.new
          else
            Calc::invalid_syntax(t.value,t.column,"The keyword let cannot be used more than once within a statement.")
          end


        when Token::IDENTIFIER
          case current
          when AST::Expression
            # When the token is an identifier and the context is an expression, it has to be an operand
            if current.left_operand.nil?
              current.left_operand = AST::Operand.new(current)
              current.left_operand.identifier = t.value
            elsif current.right_operand.nil?
              current.right_operand = AST::Operand.new(current)
              current.right_operand.identifier = t.value
              # Returns to the parent if the expression is complete (Operator and 2 Operands exist)
              current = current.parent 
            else
              Calc::invalid_syntax(t.value,t.column,"An identifier can only be used as an operand within an expression.")
            end
          when AST::Definition
            # When the token is an identifier and the context is a definition, it must be the indentifier for the expression
            if current.identifier.nil?
              current.identifier = t.value
            else
              Calc::invalid_syntax(t.value,t.column,"An identifier can only be used as an identifier within an definition.")
            end
          else
            Calc::invalid_syntax(t.value,t.column,"An identifier can only be used within an expression or definition.")
          end


        when Token::NUMBER
          case current
          when AST::Expression
            # When the token is a number and the context is an Expression, it has to be an Operand (Operators are not numbers)
            if current.left_operand.nil?
              current.left_operand = AST::Operand.new(current)
              current.left_operand.literal = t.value
            elsif current.right_operand.nil?
              current.right_operand = AST::Operand.new(current)
              current.right_operand.literal = t.value
              # Returns to the parent if the expression is complete (Operator and 2 Operands exist)
              current = current.parent
            else
              Calc::invalid_syntax(t.value,t.column,"A number can only be used as an operand within an expression.")
            end
          when AST::Definition
            # When the token is a number and the context is a definition, it has to be the value (numbers cannot be identifiers)
            current.value = t.value
            program.definitions << current
            current = nil
          else
            Calc::invalid_syntax(t.value,t.column,"A number can only be used once within a definition.")
          end


        when Token::OPERATOR
          case current
          when nil
            # If there is no context, the operator must be for the top-level expression
            current = top_expression
            current.operator = t.value
          when AST::Expression
            # When the token is an Operator and the context is an expression
            if current.operator.nil?
              # If there is no operator, assign the value to it
              current.operator = t.value
            elsif current.left_operand.nil?
              # Operator exists, left operand is empty. Need to create operand to complete the expression
              current.left_operand = AST::Operand.new(current)
              current.left_operand.expression = AST::Expression.new(program)
              current.left_operand.expression.operator = t.value
              current.left_operand.expression.parent = current
              # Nest the Expression
              current = current.left_operand.expression 
            elsif current.right_operand.nil?
              # Operator exists, right operand is empty. Need to create operand to complete the expression
              current.right_operand = AST::Operand.new(current)
              current.right_operand.expression = AST::Expression.new(program)
              current.right_operand.expression.operator = t.value
              current.right_operand.expression.parent = current
              # Nest the Expression
              current = current.right_operand.expression 
            else
              Calc::invalid_syntax(t.value,t.column,"An operator can only be used once within an expression.")
            end
          else
            Calc::invalid_syntax(t.value,t.column,"An operator can only be used within an expression.")
          end
        else
          Calc::invalid_syntax(t.type,t.column,"Invalid Token type.")
        end
      end
      program
    end
  end
end
