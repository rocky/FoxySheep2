from FoxySheep.generated.InputFormLexer import InputFormLexer
from antlr4 import InputStream, CommonTokenStream
from FoxySheep.generated.InputFormParser import InputFormParser

from FoxySheep.tree.pretty_printer import pretty_print_string
from FoxySheep.transform.if2py import input_form_to_python

import decimal
import math
import yaml
import os.path as osp

def get_srcdir():
    filename = osp.normcase(osp.dirname(osp.abspath(__file__)))
    return osp.realpath(filename)


srcdir = get_srcdir()
testdata_dir = osp.join(srcdir, "parse_expressions")

last_tree_str = ""


def parse_tree_fn(expr: str, show_tree_fn):
    global last_tree_str
    lexer = InputFormLexer(InputStream(expr))
    parser = InputFormParser(CommonTokenStream(lexer))
    tree = parser.prog()
    last_tree_str = show_tree_fn(tree, parser.ruleNames)
    return tree


pp_fn = lambda tree, rule_names: pretty_print_string(tree, rule_names, compact=True)

show_tests = True
out_results = [None]

try:
    import numpy
except ImportError:
    numpy = None
    pass


eval_namespace = {
    "out_results": out_results,
    "missing_modules": [math, decimal, numpy],
}


def do_test(input_base: str):
    testdata_path = osp.join(testdata_dir, input_base)
    with open(testdata_path, "r") as yaml_file:
        test_data = yaml.load(yaml_file, Loader=yaml.FullLoader)
        # print(test_data)

    # translation_fn = input_form_to_python
    for expr in test_data:
        numpy_str = input_form_to_python(
            expr, parse_tree_fn=parse_tree_fn, show_tree_fn=pp_fn, mode="numpy"
        )
        print(numpy_str)
        assert eval(numpy_str, None, eval_namespace)


if numpy:
    def test_foxy_to_numpy():
        do_test("numpy.yaml")


    if __name__ == "__main__":
        test_foxy_to_numpy()
