%{
#include <iostream>

using namespace std;
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


%%

function	cout << "FUNCTION\n";
beginparams
endparams
beginlocals
endlocals
beginbody
endbody
beginloop
endloop
if
then
else
endif
do
while
read
write
continue
return
true
false
and
or
not
integer
of

":="	// ASSIGN
"=="	// EQ
"<>"	// NEQ
"<"	// LT
">"	// GT
"<="	// LTE
">="	// GTE
"+"
"-"
"*"
"/"
"%"
"["
"]"
"("
")"
":"
","
";"

{id}[_]		cout << "Not an identifier\n";
{number}	cout << "Number\n";
{id}		cout << "Identifier\n";
[ \t]*		cout << "Space or tab\n";
[\n]		cout << "Newline\n";



\$		return 0;
.		cout << "Hi\n";

%%

int main(void) {
	yylex();
	return 0;
}
