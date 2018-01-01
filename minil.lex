%{
#include <iostream>

using namespace std;

int col = 1;
%}

/*	This tells flex to read only one input file	*/
%option noyywrap


/*	Identifiers must start with a letter
 *	They can contain underscores, letters, and digits
 *	They must end with a letter or a digit
*/
letter		[a-zA-Z]
digit		[0-9]
number		{digit}+
id		{letter}([_]*{letter}|[_]*{digit})*

%x comment

%%

function	col += yyleng;
beginparams	col += yyleng;
endparams	col += yyleng;
beginlocals	col += yyleng;
endlocals	col += yyleng;
beginbody	col += yyleng;
endbody		col += yyleng;
beginloop	col += yyleng;
endloop		col += yyleng;
if		col += yyleng;
then		col += yyleng;
else		col += yyleng;
endif		col += yyleng;
do		col += yyleng;
while		col += yyleng;
read		col += yyleng;
write		col += yyleng;
continue	col += yyleng;
return		col += yyleng;
true		col += yyleng;
false		col += yyleng;
and		col += yyleng;
or		col += yyleng;
not		col += yyleng;
integer		col += yyleng;
of		col += yyleng;

":="		col += yyleng;	// ASsIGN
"=="		col += yyleng;	// EQ
"<>"		col += yyleng;	// NEQ
"<"		col += yyleng;	// LT
">"		col += yyleng;	// GT
"<="		col += yyleng;	// LTE
">="		col += yyleng;	// GTE
"+"		col += yyleng;
"-"		col += yyleng;
"*"		col += yyleng;
"/"		col += yyleng;
"%"		col += yyleng;
"["		col += yyleng;
"]"		col += yyleng;
"("		col += yyleng;
")"		col += yyleng;
":"		col += yyleng;
","		col += yyleng;
";"		col += yyleng;

"##"		BEGIN(comment);
<comment>[^\n]	; 		// ignore anything that is not a newline
<comment>[\n]	{
			//	Newline breaks out of the comment
			++yylineno;
			BEGIN(INITIAL);
		}

{number}([_]|{letter})([_]|{number}|{letter})*	{
							cout << "Error at line " << yylineno << ", column " <<
								col << ": Identifier " << yytext << " must begin with a letter\n";
							return 0;
						}
{id}[_]		{
			cout << "Error at line " << yylineno << ", column " << col << ": Identifier cannot end with an underscore\n";
			return 0;
		}
{number}	col += yyleng;
{id}		col += yyleng;
[ \t]*		col += yyleng;
[\n]		{
			// Newline: Reset column to 1 and increase the line number
			col = 1;
			++yylineno;
		}



\$		return 0;
.		{
			// Syntax Error. This symbol should not be here
			cout << "Error at line " << yylineno << ", column " << col << ": Unrecognized symbol: " << yytext << endl;
			return 0;
		}

%%



int main(int argc, char** argv) {
	
	/*
	 *	If there exists input files,
	 *	Open them the first one in "read-only" mode
	*/
	if (argc > 1) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL) {
			yyin = stdin;
		}
	}
	else {
		yyin = stdin;
	}
	yylex();
	return 0;
}
