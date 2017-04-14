from antlr4 import *
from generated.FoxySheepLexer import FoxySheepLexer
from generated.FoxySheepParser import FoxySheepParser
from FoxySheep.FullFormEmitter import FullFormEmitter
 
def main():
    inputFile = "../unit_tests/ParseExpressions/NumberLiterals.m"

    #Boilerplate
    input = FileStream(inputFile)
    lexer = FoxySheepLexer(input)
    stream = CommonTokenStream(lexer)
    parser = FoxySheepParser(stream)

    tree = parser.prog()

    # Emit FullForm[]
    emitter = FullFormEmitter()
    print emitter.visit(tree)
 
if __name__ == '__main__':
    main()