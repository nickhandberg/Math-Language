module Calc
  # A module defining an Abstract Syntax Tree for Calc
  module AST
    # Represents top level program of AST
    class Program

      # Getters and setters
      attr_accessor :definitions, :expression

      # Creates and initializes instance of program
      def initialize()
        self.definitions = []
      end

      # Evaluates program
      def evaluate()
        self.expression.evaluate
      end

      # Returns definition validitiy
      def valid?
        return false if self.expression.nil?
        self.definitions.all?{|d| d.valid? } && self.expression.valid?
      end

      # Returns value of an identifier within definition
      def value_for(variable)
        d = self.definitions.select{|d| d.identifier == variable }.last
        if d
          return d.value
        end
        Calc::runtime_exception("Variable #{variable} not defined.")
      end

      # Returns string representing program
      def to_s
        self.definitions.join("\n") + "\n" + self.expression.to_s
      end
    end

    # Model of definition
    class Definition

      # Getters and setters
      attr_accessor :identifier, :value

      # Returns definition validitiy
      def valid?
        self.identifier && self.value
      end

      # Returns string representing definition
      def to_s
        "(let #{self.identifier} #{self.value})"
      end
    end

    # Model of expression
    class Expression

      # Getters and setters
      attr_accessor :program, :parent, :operator, :left_operand, :right_operand

      # Creates and initializes a new instance of expression given program
      def initialize(program)
        @program = program
      end

      # Evaluates expression from operator
      def evaluate
        case self.operator
        when "*"
          return self.left_operand.value * self.right_operand.value
        when "/"
          return self.left_operand.value / self.right_operand.value
        when "+"
          return self.left_operand.value + self.right_operand.value
        when "-"
          return self.left_operand.value - self.right_operand.value
        else
          Calc::runtime_exception("Operation not found.")
        end
      end

      # Returns expression validitiy
      def valid?
        self.operator && self.left_operand && self.right_operand
      end

      # Returns string representing expression
      def to_s
        "(#{self.operator} #{self.left_operand} #{self.right_operand})"
      end
    end

    # Model of operand
    class Operand

      # Getters and setters
      attr_accessor :literal, :identifier, :expression

      # Creates and initializes a new instance of operand given expression
      def initialize(expression)
        @expression = expression
      end

      # Returns value of operand
      # Can be a sub-expression, literal value, or identifier
      def value
        return self.expression.program.value_for(self.identifier) unless self.identifier.nil?
        return self.literal unless self.literal.nil?
        return self.expression.evaluate unless self.expression.nil?
        Calc::runtime_exception("Operand not defined")
      end

      # Returns string representing operand
      def to_s
        self.literal || self.identifier || self.expression.to_s
      end
    end
  end
end
