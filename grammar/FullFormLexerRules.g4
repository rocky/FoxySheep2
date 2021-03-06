lexer grammar FullFormLexerRules;

// LEXER RULES

// Identifiers/Names
Name
	:	LetterForm+ LetterFormOrDigit*
	;

//Too many fragments in this section?
fragment
LetterFormOrDigit :	LetterForm | DIGIT ;
fragment
LetterForm	: Letter | Letterlike | LetterName ;
fragment
Letter : [a-zA-Z\u00c0-\u00d6\u00d8-\u00f6\u00f8-\u0103\u0106\u0107\u010c-\u010f\u0112-\u0115\u011a-\u012d\u0131\u0141\u0142\u0147\u0148\u0150-\u0153\u0158-\u0161\u0164\u0165\u016e-\u0171\u017d\u017e\u0391-\u03a1\u03a3-\u03a9\u03b1-\u03c9\u03d1\u03d2\u03d5\u03d6\u03da-\u03e1\u03f0\u03f1\u03f5\u210a-\u210c\u2110-\u2113\u211b\u211c\u2128\u212c\u212d\u212f-\u2131\u2133-\u2138\uf6b2-\uf6b5\uf6b7\uf6b9\uf6ba-\uf6bc\uf6be\uf6bf\uf6c1-\uf700\uf730\uf731\uf770\uf772\uf773\uf776\uf779\uf77a\uf77d-\uf780\uf782-\uf78b\uf78d-\uf78f\uf790\uf793-\uf79a\uf79c-\uf7a2\uf7a4-\uf7bd\uf800-\uf833\ufb01\ufb02];
fragment
Letterlike : [\u0024\u00a1\u00a2\u00a3\u00a5\u00a7\u00a9\u00ab\u00ae\u00b0\u00b5\u00b6\u00b8\u00bb\u00bf\u02c7\u02d8\u2013\u2014\u2020\u2021\u2022\u2026\u2032\u2033\u2035\u2036\u2060\u20ac\u210f\u2122\u2127\u212b\u21b5\u2205\u221e\u221f\u2220\u2221\u2222\u22ee\u22ef\u22f0\u22f1\u2300\u2318\u231a\u23b4\u23b5\u2500\u2502\u25a0\u25a1\u25aa\u25ae\u25af\u25b2\u25b3\u25bc\u25bd\u25c0\u25c6\u25c7\u25cb\u25cf\u25e6\u25fb\u25fc\u2605\u2639\u263a\u2660\u2661\u2662\u2663\u266d\u266e\u266f\u2736\uf3a0\uf3b8\uf3b9\uf527\uf528\uf720\uf721\uf722\uf723\uf725\uf749\uf74a\uf74d\uf74e\uf74f\uf750\uf751\uf752\uf753\uf754\uf755\uf756\uf757\uf760\uf763\uf766\uf768\uf769\uf76a\uf76b\uf76c\uf7d4\uf800\uf801\uf802\uf803\uf804\uf805\uf806\uf807\uf808\uf809\uf80a\uf80b\uf80c\uf80d\uf80e\uf80f\uf810\uf811\uf812\uf813\uf814\uf815\uf816\uf817\uf818\uf819\uf81a\uf81b\uf81c\uf81d\uf81e\uf81f\uf820\uf821\uf822\uf823\uf824\uf825\uf826\uf827\uf828\uf829\uf82a\uf82b\uf82c\uf82d\uf82e\uf82f\uf830\uf831\uf832\uf833\ufe35\ufe36\ufe37\ufe38];

LetterName	 : RAWBACKSLASH LBRACKET LetterInner RBRACKET ;
LetterInner  : GreekLetterInner  | VariantLetterInner ;

// From https://reference.wolfram.com/language/guide/GreekLetters.html
GreekLetterInner : LowerCaseGreekInner | UpperCaseGreekInner | VariantGreekInner | ArchaicGreekInner ;

LowerCaseGreekInner : 'Alpha'   | 'Beta'  | 'Gamma'   | 'Delta' | 'Epsilon' | 'Zeta' | 'Eta'
                    | 'Theta'   | 'Iota'  | 'Lambda'  | 'Kappa' | 'Mu'      | 'Nu'   | 'Xi'
                    | 'Omicron' | 'Pi'    | 'Sigma'   | 'Tau'   | 'Upsilon' | 'Phi'  | 'Chi'
                    | 'Psi'     | 'Omega'
    ;

UpperCaseGreekInner : 'CapitalAlpha'   | 'CapitalBeta'  | 'CapitalGamma'   | 'CapitalDelta' | 'CapitalEpsilon' | 'CapitalZeta' | 'CapitalEta'
                    | 'CapitalTheta'   | 'CapitalIota'  | 'CapitalLambda'  | 'CapitalKappa' | 'CapitalMu'      | 'CapitalNu'   | 'CapitalXi'
                    | 'CapitalOmicron' | 'CapitalPi'    | 'CapitalSigma'   | 'CapitalTau'   | 'CapitalUpsilon' | 'CapitalPhi'  | 'CapitalChi'
                    | 'CapitalPsi'     | 'CapitalOmega'
    ;

// From https://reference.wolfram.com/language/guide/VariantLetters.html
VariantGreekInner   : 'CurlyEpsilon'   | 'CurlyTheta'   | 'CurlyKappa'     | 'CurlyPi'      | 'CurlyRho'  | 'FinalSigma'  | 'CurlyPhi'
                    | 'CurlyCapitalUpsilon' ;

// Back to https://reference.wolfram.com/language/guide/GreekLetters.html
ArchaicGreekInner   : 'Digamma' | 'Koppa' | 'Stigma'
                    | 'CapitalDigamma' | 'CapitalKoppa' | 'CapitalStigma' | 'CapitalSampi'
    ;

// Back to https://reference.wolfram.com/language/guide/VariantLetters.html
VariantLetterInner: LanguageNotationInner | DoubledLetterInner | SpecialLetterBasedInner | DotlessLetterInner;

LanguageNotationInner  : 'ImaginaryI'     | 'ConstantC'    | 'DifferentialD'  | 'ExponentialE' | 'ImaginaryJ' ;
DoubledLetterInner     : 'DoubledGamma'   | 'DoubledPi' ;

SpecialLetterBasedInner : 'Micro' | 'Anstrom' | 'HBar' | 'WeierstrassP' ;

DotlessLetterInner  : 'DotlessI' | 'DotlessJ' | 'ScriptDotlessI' | 'ScriptDotlessJ' ;

//Number Representations
//
DecimalNumber
	:	DIGITS DOT DIGIT* 	//We can omit numbers after the decimal point and not before, or...
	|	DIGIT* DOT DIGITS 	//...before the decimal point and not after.
//	|	DIGITS				//Or we don't need a decimal point.
	;

NumberInBase
	:	DOUBLECARET (DigitInAnyBase+ DOT? DigitInAnyBase* | DigitInAnyBase* DOT? DigitInAnyBase+)
	;

DIGITS : DIGIT+;
fragment
DIGIT	: [0-9];
fragment
DigitInAnyBase
	:	DIGIT
	|	[a-zA-Z]
	;

//String Literal
//TODO: This section is not correct. It does not match "Hello,\- world!" which is a valid string.
//		Mathics has similar issues, e.g. doesn't match "Hello,\ world!"
StringLiteral
    :   QUOTE StringCharacters? QUOTE
    ;

fragment
StringCharacters
    :   StringCharacter+
    ;

fragment
StringCharacter
    :   ~["\\]
    |   EscapeSequence
    ;

// Escape Sequences for Character and String Literals
fragment
EscapeSequence
    :   RAWBACKSLASH [btnfr"'\\]
    |   UnicodeEscape
    ;

fragment
UnicodeEscape
    :   RAWBACKSLASH RAWCOLON HexDigit HexDigit HexDigit HexDigit
    ;

fragment
HexDigit
    :   [0-9a-fA-F]
    ;

PLUS		: '+';
MINUS	: '-';

//Comments
COMMENT
	:	LCOMMENT .*? RCOMMENT -> skip
	;

// Separators and brackets
LBRACKET      : '['; //{self.incrementBracketLevel(1);} ;
RBRACKET      : ']'; //{self.incrementBracketLevel(-1);} ;
COMMA       : ',';
LCOMMENT		: '(*';
RCOMMENT		: '*)';

//Quote Characters
DOUBLEBACKQUOTE	: '``';
BACKQUOTE	: '`';
SINGLEQUOTE	: '\'';
QUOTE		: '"';

//Miscellaneous Punctuation
RAWCOLON			: ':';
RAWBACKSLASH		: '\\';
DOUBLECARET		: '^^';
ASTERISKCARET	: '*^';
DOT				: '.';

NEWLINE	: '\n' -> skip ; //{ self.checkNewline();} ;

CONTINUATION	:	'\uf3b1' -> skip ;
WHITESPACE  :   ([\t\r] | SpaceCharacter)+ -> skip ;
fragment SpaceCharacter
	:	' '
	|	'\u2009' //ThinSpace
	|	'\u200a' //VeryThinSpace
	|	'\u205f' //MediumSpace
	|	'\u2005' //ThickSpace
	|	'\uf380' //NegativeVeryThinSpace
	|	[\uf382-\uf384] //NegativeThinSpace, NegativeMediumSpace, NegativeThickSpace
	|	'\u2423' //SpaceIndicator
	;
