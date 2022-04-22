require 'calc/ast'
require 'calc/token'
require 'calc/parser'
require 'calc/lexer'
require 'calc/evaluator'

module Calc
  # Prints error messages for invalid syntax
  def self.invalid_syntax(s,c,reason)
    $stderr.puts "Invalid syntax near #{s} (column: #{c})"
    $stderr.puts reason
    exit 1
  end

  # Prints runtime errors
  def self.runtime_exception(e)
    $stderr.puts "[RUNTIME ERROR]: #{e}"
    exit 1
  end
end