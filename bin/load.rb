#!/usr/bin/env ruby

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","lib"))

require 'calc'

f = File.open(ARGV[0]).read
# Invoke the Lexer with the input, the Parser with the tokens, and the Evaluator with the AST.
puts Calc::Evaluator.evaluate(Calc::Parser.parse(Calc::Lexer.lex(f)))