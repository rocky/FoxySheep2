from FoxySheep.transform.if2py import symbol_replace_re, replace_symbols_with_unicode

def test_symbol_replace_with_unicode():
    for s, expect_str, is_symbol in (
            ("\\[Alpha]1", "α1", True),
            ("\\[Omega]", "ω", True),
            ("foo", "foo", False)
    ):
        assert bool(symbol_replace_re.match(s)) == is_symbol
        assert replace_symbols_with_unicode(s), expect_str
