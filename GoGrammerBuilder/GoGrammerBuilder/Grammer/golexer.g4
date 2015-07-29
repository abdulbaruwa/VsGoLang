
lexer grammar golexer;
/*
 * Lexer Rules
 */

NEW_LINE 
	: ('\u000A' ) -> channel(HIDDEN)
	;

SINGLE_LINE_COMMENT 
	: ('//' Input_character*) -> channel(HIDDEN)
	;

UNICODE_CHAR
	: Input_character
	;

fragment Input_characters
	: Input_character+
	;

fragment Input_character  
	: ~([\u000D\u000A\u0085\u2028\u2029]) //'<Any Unicode Character Except A NEW_LINE_CHARACTER>' 
	;
WS
	:	(' ', '\r' | '\n') -> channel(HIDDEN)
	;

DECIMALDIGIT
	: Decimal_digit
	;

fragment Decimal_digit
	: '0'..'9' 
	; 
BYTE_VALUE
	:  OCTAL_BYTE_VALUE | HEX_BYTE_VALUE
	;
	 
OCTAL_BYTE_VALUE
	: '\\' Octal_digit Octal_digit Octal_digit
	;

OCTALDIGIT
	: Octal_digit
	;

fragment Octal_digit
	: '0'..'7'
	;

HEX_DIGIT 
	: Hex_digit
	;
fragment Hex_digit
	: '0'..'0'
	| 'A'..'F'
	| 'a'..'f'
	;

UNICODE_LETTER
	: Letter_character
	;

LETTER 
	: Letter_character
	| '_'
	;

UNICODE_DIGIT
	: UNICODE_CLASS_ND
	;

// Literals
//Integer literals
INT_LITERAL
	: Decimal_literal | Octal_literal | Hex_literal
	; 

fragment Decimal_literal 
	:  ('1'..'9') Decimal_digits //{ Decimal_digit }
	;

fragment Decimal_digits
	: Decimal_digit+
	;

fragment Octal_literal
	: '0' Octal_digits // { Octal_digit }
	;
fragment Octal_digits
	: Octal_digit+
	;

LITTLE_U_VALUE
	: '\\u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
	;

BIG_U_VALUE
	: '\\U' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
	;

HEX_BYTE_VALUE
	: '\\x' HEX_DIGIT HEX_DIGIT 	
	;

fragment Hex_literal 
	: ('0x'|'0X') Hex_digits
	;

fragment Hex_digits
	: Hex_digit+
	;

ESCAPED_CHAR
	: '\\' ( 'a' | 'b' | 'f' | 'n' | 'r' | 't' | 'v' | BACK_SLASH | QUOTE | DOUBLE_QUOTE )
	;

// Floating-point literals
//#Todo

//Imaginary literals
//#Todo

//Rune literals
Rune_literal 
	: QUOTE (UNICODE_VALUE | BYTE_VALUE) QUOTE
	;

UNICODE_VALUE
	: UNICODE_CHAR
	| LITTLE_U_VALUE
	| BIG_U_VALUE
	| ESCAPED_CHAR
	;
	 
//#Todo

//String literals
String_Literal
	: Raw_string_literal | Interpreted_string_literal
	;

Raw_string_literal
	: QUOTE { UNICODE_CHAR | NEW_LINE } QUOTE
	;

Interpreted_string_literal
	: DOUBLE_QUOTE  { UNICODE_VALUE | BYTE_VALUE } DOUBLE_QUOTE 
	;


fragment Letter_character 
  : UNICODE_CLASS_LU
  | UNICODE_CLASS_LL
  | UNICODE_CLASS_LT
  | UNICODE_CLASS_LM
  | UNICODE_CLASS_LO
  | UNICODE_CLASS_NL
	//  | '<A Unicode_escape_sequence Representing A Character Of Classes Lu, Ll, Lt, Lm, Lo, Or Nl>'
  ;
fragment UNICODE_CLASS_LU
  : '\u0041'..'\u005A' // LATIN CAPITAL LETTER A_Z
  | '\u00C0'..'\u00DE' // ACCENTED CAPITAL LETTERS
	//  | { isUnicodeClass_Lu($text) }?
  ;

fragment UNICODE_CLASS_LL
  : '\u0061'..'\u007A' // LATIN SMALL LETTER a_z
  ;


fragment UNICODE_CLASS_LT
  : '\u01C5' // LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON
  | '\u01C8' // LATIN CAPITAL LETTER L WITH SMALL LETTER J
  | '\u01CB' // LATIN CAPITAL LETTER N WITH SMALL LETTER J
  | '\u01F2' // LATIN CAPITAL LETTER D WITH SMALL LETTER Z
  ;

fragment UNICODE_CLASS_LM
  : '\u02B0'..'\u02EE' // MODIFIER LETTERS
  ;

fragment UNICODE_CLASS_LO
  : '\u01BB' // LATIN LETTER TWO WITH STROKE
  | '\u01C0' // LATIN LETTER DENTAL CLICK
  | '\u01C1' // LATIN LETTER LATERAL CLICK
  | '\u01C2' // LATIN LETTER ALVEOLAR CLICK
  | '\u01C3' // LATIN LETTER RETROFLEX CLICK
  | '\u0294' // LATIN LETTER GLOTTAL STOP
  ;

fragment UNICODE_CLASS_NL
  : '\u16EE' // RUNIC ARLAUG SYMBOL
  | '\u16EF' // RUNIC TVIMADUR SYMBOL
  | '\u16F0' // RUNIC BELGTHOR SYMBOL
  | '\u2160' // ROMAN NUMERAL ONE
  | '\u2161' // ROMAN NUMERAL TWO
  | '\u2162' // ROMAN NUMERAL THREE
  | '\u2163' // ROMAN NUMERAL FOUR
  | '\u2164' // ROMAN NUMERAL FIVE
  | '\u2165' // ROMAN NUMERAL SIX
  | '\u2166' // ROMAN NUMERAL SEVEN
  | '\u2167' // ROMAN NUMERAL EIGHT
  | '\u2168' // ROMAN NUMERAL NINE
  | '\u2169' // ROMAN NUMERAL TEN
  | '\u216A' // ROMAN NUMERAL ELEVEN
  | '\u216B' // ROMAN NUMERAL TWELVE
  | '\u216C' // ROMAN NUMERAL FIFTY
  | '\u216D' // ROMAN NUMERAL ONE HUNDRED
  | '\u216E' // ROMAN NUMERAL FIVE HUNDRED
  | '\u216F' // ROMAN NUMERAL ONE THOUSAND
  ;

fragment UNICODE_CLASS_ND
  : '\u0030' // DIGIT ZERO
  | '\u0031' // DIGIT ONE
  | '\u0032' // DIGIT TWO
  | '\u0033' // DIGIT THREE
  | '\u0034' // DIGIT FOUR
  | '\u0035' // DIGIT FIVE
  | '\u0036' // DIGIT SIX
  | '\u0037' // DIGIT SEVEN
  | '\u0038' // DIGIT EIGHT
  | '\u0039' // DIGIT NINE
  ;

//Keywords
BREAK: 'break';
DEFAULT:  'default';
FUNC: 'func';
INTERFACE: 'interface';
SELECT: 'select';
CASE: 'case';
DEFER: 'defer';
GO: 'go';
MAP: 'map';
STRUCT: 'struct';
CHAN: 'chan';
ELSE: 'else';
GOTO: 'goto';
PACKAGE: 'package';
SWITCH: 'switch';
CONST: 'const';
FALLTHROUGH: 'fallthrough';
IF: 'if';
RANGE: 'range';
TYPE: 'type';
CONTINUE: 'continue';
FOR: 'for';
IMPORT: 'import';
VAR: 'var';

//identifiers
//As per C# sample  (// must be defined after all keywords so the first branch (Available_identifier) does not match keywords)
IDENTIFIER
	: LETTER {LETTER | UNICODE_DIGIT} 
	;

 
// Operators, delimiters and special tokens
PLUS : '+';
AMP : '&';
COLON : ':';
OP_ADD_ASSIGNMENT : '+=';
OP_SUB_ASSIGNMENT : '-=';
OP_AMP_ASSIGNMENT : '&=';
OP_MULT_ASSIGNMENT : '*=';
OP_XOR_ASSIGNMENT : '^=';
OP_DIV_ASSIGNMENT : '/=';
OP_LEFT_SHIFT : '<<';
OP_RIGHT_SHIFT : '>>';
OP_LEFT_SHIFT_ASSIGNMENT: '<<=';
OP_RIGHT_SHIFT_ASSIGNMENT: '>>=';
OP_MOD_ASSIGNMENT : '%=';
OP_AMP_CLARET_ASSIGNMENT: '&^=';
OP_OPTIONAL: '<-';
OP_AND : '&&';
OP_EQ : '==';
OP_NE : '!=';
OP_OR_EQ : '|=';
OP_LE : '<=';
OP_GE : '>=';
LT : '<';
GT : '>';
MINUS : '-';
CARET : '^';
STAR : '*';
PERCENT : '%';
DOT : '.';
OPEN_BRACE : '{';
CLOSE_BRACE : '}';
OPEN_PARENS : '(';
CLOSE_PARENS : ')';
OPEN_BRACKET : '[';
CLOSE_BRACKET : ']';
OP_OR : '||';
OP_INC : '++';
OP_DEC : '--';
AMP_CLARET: '&^';
TRIPLE_DOT: '...';
COMMA : ',';
SEMICOLON : ';';
DIV : '/';
BITWISE_OR : '|';
ASSIGNMENT: '=';
OP_COLON_ASSIGN : ':=';
BANG : '!';

//Custom Lexer rules
QUOTE :             '\'';
DOUBLE_QUOTE :      '"';
BACK_SLASH :        '\\';
DOUBLE_BACK_SLASH : '\\\\';