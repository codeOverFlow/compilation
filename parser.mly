%{
        open Definitions
        (** Overrides the default parse_error function. *)
        let parse_error s = Errors.error "Parsing error" (symbol_start_pos ())
%}

%token PRINT
%token EOF
%token SLEEP
%token ENDIF
%token<string> STRING
%token<string> COMMENT
%token<string> IF
%token<string> ELSE
%start bas_file
%type<unit> bas_file
%%

bas_file:
        debut lines fin EOF { $1; $2; $3}
;

debut:
        { 
                print_endline "#include <stdio.h>";
                print_endline "#include <stdlib.h>";
                print_endline "int main (void) {";
        }
;

fin:
        {
                print_endline "return EXIT_SUCCESS;";
                print_endline "}"
        }
;

lines:
        /* empty */  {}
        | lines code comment {}
;

code:
        /* empty */    {}
        | PRINT STRING { print_string "printf("; print_string $2; print_endline ");" }
        | SLEEP        { print_endline "getchar();" }
        | IF           { print_endline $1 }
        | ELSE         { print_endline $1 }
        | ENDIF        { print_endline "}" }
;

comment:
        /* empty */    {}
        | COMMENT      { print_endline $1 }
;
