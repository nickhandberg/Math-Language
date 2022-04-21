# Adds the lib directory to Ruby's load path
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","lib"))

require 'calc'

# Opens and reads the file
f = File.open(ARGV[0]).read

# Passes the file to the Lexer, parses the return of the lexer and evaluates
puts Calc::Evaluator.evaluate(Calc::Parser.parse(Calc::Lexer.lex(f)))