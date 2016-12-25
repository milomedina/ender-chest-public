from miniclex import MiniCLexer, tokens
from node._struct import *
import ply.yacc as yacc


start = 'program'
precedence = (
    ('nonassoc', 'IFX'),
    ('nonassoc', 'ELSE'),
    ('right', 'ASSIGN'),
    ('left', 'EQ', 'NEQ'),
    ('left', 'LT', 'GT', 'LTE', 'GTE'),
    ('left', 'PLUS', 'MINUS'),
    ('left', 'MULTI', 'DIV'),
    ('right', 'UMINUS'),
    ('left', 'FUNC'),
)


def m(p):
    return p


# EMPTY
def p_empty(p):
    'empty :'
    pass


# PROGRAM
def p_program_decllist_funclist(p):
    'program : decllist funclist'
    p[0] = Program(m(p), p[1], p[2])


def p_program_decllist(p):
    'program : decllist'
    p[0] = Program(m(p), p[1], [])


def p_program_funclist(p):
    'program : funclist'
    p[0] = Program(m(p), [], p[1])


def p_program_empty(p):
    'program : empty'
    p[0] = Program(m(p), [], [])


# DECLLIST
def p_decllist_one(p):
    'decllist : declaration'
    p[0] = [p[1], ]


def p_decllist_many(p):
    'decllist : decllist declaration'
    p[0] = p[1] + [p[2], ]


# FUNCLIST
def p_funclist_one(p):
    'funclist : function'
    p[0] = [p[1], ]


def p_funclist_many(p):
    'funclist : funclist function'
    p[0] = p[1] + [p[2], ]


# DECLARATION
def p_declaration(p):
    'declaration : type idenlist SEMI'
    p[0] = Declaration(m(p), p[1], p[2])


# IDENLIST
def p_idenlist_one(p):
    'idenlist : identifier'
    p[0] = [p[1], ]


def p_idenlist_many(p):
    'idenlist : identifier COMMA idenlist'
    p[0] = [p[1], ] + p[3]


# IDENTIFIER
def p_identifier_noarr(p):
    'identifier : ID'
    p[0] = Identifier(m(p), p[1])


def p_identifier_arr(p):
    'identifier : ID LBRACKET INTNUM RBRACKET'
    p[0] = Identifier(m(p), p[1], p[3])


# FUNCTION
def p_function_noparams(p):
    'function : type ID LPAREN RPAREN compoundstmt'
    p[0] = Function(m(p), p[1], p[2], [], p[5])


def p_function_params(p):
    'function : type ID LPAREN paramlist RPAREN compoundstmt'
    p[0] = Function(m(p), p[1], p[2], p[4], p[6])


# PARAMLIST
def p_paramlist_one(p):
    'paramlist : type identifier'
    p[0] = [Param(m(p), p[1], p[2]), ]


def p_paramlist_many(p):
    'paramlist : paramlist COMMA type identifier'
    p[0] = p[1] + [Param(m(p), p[3], p[4]), ]


# TYPE
def p_type(p):
    '''type : INT
            | FLOAT'''
    p[0] = p[1]


# COMPOUNDSTMT
def p_compoundstmt_nodecllist(p):
    'compoundstmt : LBRACE stmtlist RBRACE'
    p[0] = CompoundStmt(m(p), [], p[2])


def p_compoundstmt_decllist(p):
    'compoundstmt : LBRACE decllist stmtlist RBRACE'
    p[0] = CompoundStmt(m(p), p[2], p[3])


# STMTLIST
def p_stmtlist_empty(p):
    'stmtlist : empty'
    p[0] = []


def p_stmtlist_many(p):
    'stmtlist : stmtlist stmt'
    p[0] = p[1] + [p[2], ]


# STMT
def p_stmt(p):
    '''stmt : assignstmt
            | callstmt
            | retstmt
            | whilestmt
            | forstmt
            | ifstmt
            | switchstmt
            | compoundstmt
            | nullstmt'''
    p[0] = p[1]


# ASSIGNSTMT
def p_assignstmt(p):
    'assignstmt : assign SEMI'
    p[0] = p[1]


# ASSIGN
def p_assign_notarr(p):
    'assign : ID ASSIGN expr'
    p[0] = AssignStmt(m(p), p[1], p[3])


def p_assign_arr(p):
    'assign : ID LBRACKET expr RBRACKET ASSIGN expr'
    p[0] = AssignStmt(m(p), p[1], p[6], p[3])


# CALLSTMT
def p_callstmt(p):
    'callstmt : call SEMI'
    name, args = p[1]
    p[0] = CallStmt(m(p), name, args)


# CALL
def p_call_noargs(p):
    'call : ID LPAREN RPAREN %prec FUNC'
    p[0] = p[1], []


def p_call_args(p):
    'call : ID LPAREN arglist RPAREN %prec FUNC'
    p[0] = p[1], p[3]


# RETSTMT
def p_retstmt_noval(p):
    'retstmt : RETURN SEMI'
    p[0] = RetStmt(m(p))


def p_retstmt_val(p):
    'retstmt : RETURN expr SEMI'
    p[0] = RetStmt(m(p), p[2])


# WHILESTMT
def p_whilestmt_cat1(p):
    'whilestmt : WHILE LPAREN expr RPAREN stmt'
    p[0] = WhileStmt(m(p), p[3], p[5])


def p_whilestmt_cat2(p):
    'whilestmt : DO stmt WHILE LPAREN expr RPAREN SEMI'
    p[0] = DoWhileStmt(m(p), p[5], p[2])


# FORSTMT
def p_forstmt(p):
    'forstmt : FOR LPAREN assign SEMI expr SEMI assign RPAREN stmt'
    p[0] = ForStmt(m(p), p[3], p[5], p[7], p[9])


# IFSTMT
def p_ifstmt_noelse(p):
    'ifstmt : IF LPAREN expr RPAREN stmt %prec IFX'
    p[0] = IfStmt(m(p), p[3], p[5])


def p_ifstmt_else(p):
    'ifstmt : IF LPAREN expr RPAREN stmt ELSE stmt'
    p[0] = IfStmt(m(p), p[3], p[5], p[7])


# SWITCHSTMT
def p_switchstmt(p):
    'switchstmt : SWITCH LPAREN identifier RPAREN LBRACE caselist RBRACE'
    p[0] = SwitchStmt(m(p), p[3], p[6])


# CASELIST
def p_caselist_nodefault(p):
    'caselist : numcaselist'
    p[0] = CaseList(m(p), p[1])


def p_caselist_default(p):
    'caselist : numcaselist defaultcase'
    p[0] = CaseList(m(p), p[1], p[2])


# NUMCASELIST
def p_numcaselist_empty(p):
    'numcaselist : empty'
    p[0] = []


def p_numcaselist_many(p):
    'numcaselist : numcaselist CASE INTNUM COLON casebody'
    num, has_break = p[5]
    p[0] = p[1] + [NumCase(m(p), p[3], num, has_break), ]


# DEFAULTCASE
def p_defaultcase(p):
    'defaultcase : DEFAULT COLON casebody'
    num, has_break = p[3]
    p[0] = DefaultCase(m(p), num, has_break)


# CASEBODY
def p_casebody_nobreak(p):
    'casebody : stmtlist BREAK SEMI'
    p[0] = (p[1], True)


def p_casebody_break(p):
    'casebody : stmtlist'
    p[0] = (p[1], False)


# NULLSTMT
def p_nullstmt(p):
    'nullstmt : SEMI'
    p[0] = NullStmt(m(p))


# EXPR
def p_expr_unop(p):
    'expr : MINUS expr %prec UMINUS'
    p[0] = UnopExpr(m(p), p[1], p[2])


def p_expr_binop(p):
    '''expr : expr PLUS expr
            | expr MINUS expr
            | expr MULTI expr
            | expr DIV expr
            | expr GT expr
            | expr LT expr
            | expr GTE expr
            | expr LTE expr
            | expr EQ expr
            | expr NEQ expr'''
    p[0] = BinopExpr(m(p), p[2], p[1], p[3])


def p_expr_call(p):
    'expr : call'
    name, args = p[1]
    p[0] = CallExpr(m(p), name, args)


def p_expr_num(p):
    '''expr : INTNUM
            | FLOATNUM'''
    p[0] = NumExpr(m(p), p[1])


def p_expr_id(p):
    'expr : ID'
    p[0] = IDExpr(m(p), p[1])


def p_expr_idarr(p):
    'expr : ID LBRACKET expr RBRACKET'
    p[0] = IDExpr(m(p), p[1], p[3])


def p_expr_paren(p):
    'expr : LPAREN expr RPAREN'
    p[0] = p[2]


# ARGLIST
def p_arglist_one(p):
    'arglist : expr'
    p[0] = [p[1], ]


def p_arglist_many(p):
    'arglist : arglist COMMA expr'
    p[0] = p[1] + [p[3], ]


# ERROR
def p_error(p):
    print("Syntax error at token - type=%s, val=%s, line=%s, lexpos=%s" %
          (p.type, p.value, p.lineno, p.lexpos))
    raise SyntaxError


_l = MiniCLexer()
lexer = _l.build()
parser = yacc.yacc()
