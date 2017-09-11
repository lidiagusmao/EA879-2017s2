%{
#include <stdio.h>
#include "imageprocessing.h"
#include <FreeImage.h>

void yyerror(char *c);
int yylex(void);

%}
%union {
  char    strval[50];
  int     ival;
}
%token <strval> STRING STRINGX
%token <ival> VAR IGUAL EOL ASPA OPE NUM
%left SOMA

%%

PROGRAMA:
        PROGRAMA EXPRESSAO EOL
        |
        ;

EXPRESSAO:
    STRING IGUAL STRING | {
        printf("Copiando %s para %s\n", $3, $1);
        imagem I = abrir_imagem($3);
        printf("Li imagem %d por %d\n", I.width, I.height);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                                }
    ;

BRILHO: 
    STRING IGUAL STRING OPE NUM | {
        printf("Aplicando %s em %s\n", $5, $3);
        brilho($3, $5, $4);
        salvar_imagem($1, &I);
        liberar_imagem(&I);
                                 }  

    ;

VALORMAXIMO:
   STRINGX | {
        printf("Achando o valor máximo de %s\n", $1);
        busca($1);
                                } 
   ;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main() {
  FreeImage_Initialise(0);
  yyparse();
  return 0;

}