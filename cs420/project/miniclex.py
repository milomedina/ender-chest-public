import ply.lex as lex

reserved = {
    'int': 'INT',
    'float': 'FLOAT',
    'return': 'RETURN',
    'while': 'WHILE',
    'do': 'DO',
    'for': 'FOR',
    'if': 'IF',
    'else': 'ELSE',
    'switch': 'SWITCH',
    'case': 'CASE',
    'default': 'DEFAULT',
    'break': 'BREAK',
}

tokens = [
    # Binary Operator
    'PLUS',
    'MINUS',
    'MULTI',
    'DIV',
    'GT',
    'LT',
    'GTE',
    'LTE',
    'EQ',
    'NEQ',

    # Assignment
    'ASSIGN',

    # Parenthesis
    'LPAREN',
    'RPAREN',
    'LBRACE',
    'RBRACE',
    'LBRACKET',
    'RBRACKET',

    # Colons, etc
    'COMMA',
    'COLON',
    'SEMI',

    # Numbers, Identifiers
    'FLOATNUM',
    'INTNUM',
    'ID',
] + list(reserved.values())


class MiniCLexer:
    reserved = reserved
    tokens = tokens

    t_PLUS = r'\+'
    t_MINUS = r'\-'
    t_MULTI = r'\*'
    t_DIV = r'\/'
    t_GT = r'>'
    t_LT = r'<'
    t_GTE = r'>='
    t_LTE = r'<='
    t_EQ = r'=='
    t_NEQ = r'!='

    t_ASSIGN = r'='

    t_COMMA = ','
    t_COLON = ':'
    t_SEMI = ';'

    t_LPAREN = r'\('
    t_RPAREN = r'\)'
    t_LBRACE = r'\{'
    t_RBRACE = r'\}'
    t_LBRACKET = r'\['
    t_RBRACKET = r'\]'

    def t_FLOATNUM(self, t):
        r'[0-9]+\.[0-9]+'
        t.value = float(t.value)
        return t

    def t_INTNUM(self, t):
        r'[0-9]+'
        t.value = int(t.value)
        return t

    def t_ID(self, t):
        r'[a-zA-Z][a-zA-Z0-9_]*'
        t.type = self.reserved.get(t.value, 'ID')
        return t

    def t_COMMENT(self, t):
        r'/\*(.|\n)*?\*/'
        pass

    def t_newline(self, t):
        r'\n+'
        t.lexer.lineno += len(t.value)

    t_ignore = ' \t'

    def t_error(self, t):
        print("Illegal character '%s'" % t.value[0])
        t.lexer.skip(1)

    def build(self, **kwargs):
        self.lexer = lex.lex(module=self, **kwargs)
        return self.lexer
