type svalue = Tokens.svalue
type pos = int
type ('a,'b) token = ('a,'b) Tokens.token
type lexresult = (svalue,pos) token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos
fun err(p1,p2) = ErrorMsg.error p1

fun eof() = let val pos = hd(!linePos) in Tokens.EOF(pos,pos) end


%%
%header (functor SLPLexFun(structure Tokens: SLP_TOKENS));
digit = [0-9];
letter = [A-Za-z];
space = [\ \t\f];
%%
\n	=> (lineNum := !lineNum+1; linePos := yypos :: !linePos; continue());
{space}+ => (continue());
","	=> (Tokens.COMMA(yypos,yypos+1));
";"	=> (Tokens.SEMICOLON(yypos,yypos+1));
"+"	=> (Tokens.PLUS(yypos,yypos+1));
"-"	=> (Tokens.MINUS(yypos,yypos+1));
"/"	=> (Tokens.DIVIDE(yypos,yypos+1));
"*"	=> (Tokens.TIMES(yypos,yypos+1));
"("	=> (Tokens.LPAREN(yypos,yypos+1));
")"	=> (Tokens.RPAREN(yypos,yypos+1));
":="	=> (Tokens.ASSIGN(yypos,yypos+2));
"print"       => (Tokens.PRINT(yypos,yypos+5));
{letter}({letter}|{digit})* => (Tokens.ID(yytext,yypos,yypos+size(yytext)));
{digit}+ => (case Int.fromString(yytext) of
	       NONE => raise Fail ("couldnt parse number: " ^ yytext)
	     | SOME intVal =>
	       Tokens.INT(intVal,yypos,yypos+size(yytext)));
.               => (ErrorMsg.error yypos ("illegal character " ^ yytext); continue());
