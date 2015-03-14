{
        (* Open the parser module for the tokens declarations. *)
        open Parser
                (* Open the lexing module to update lexbuf position. *)
        open Lexing
        (** Increments the lexing buffer line number counter.*)
        let incr_line lexbuf =
                let pos = lexbuf.lex_curr_p in
                lexbuf.lex_curr_p <-
                        {pos with pos_lnum = pos.pos_lnum + 1; pos_bol = 0}
                        (** Increments the lexing buffer line offset by the given length. *)
        let incr_bol lexbuf length =
                let pos = lexbuf.lex_curr_p in
                lexbuf.lex_curr_p <- {pos with pos_bol = pos.pos_bol + length}
                (** Increments the lexing buffer line offset by the given lexem length. *)
        let incr_bol_lxm lexbuf lxm = incr_bol lexbuf (String.length lxm)
        (** Turns a char into a string containing this char. *)
        let string_of_char c = String.make 1 c
        let buffer = Buffer.create 20
}


let alpha_char = ['a'-'z' 'A'-'Z' '_']
let digit      = ['0'-'9']
let identifier = alpha_char (alpha_char | digit)*
let print      = ('p'|'P') ('r'|'R') ('i'|'I') ('n'|'N') ('t'|'T')
let sleep      = ('s'|'S') ('l'|'L') ('e'|'E') ('e'|'E') ('p'|'P')
let rem        = ('r'|'R') ('e'|'E') ('m'|'M')
let cond       = ('i'|'I') ('f'|'F')
let mthen      = ('t'|'T') ('h'|'H') ('e'|'E') ('n'|'N')


        (** The main lexing rule. *)
rule token = parse
  (* Tokens to send to the parser. *)
  | '\n'         { incr_line lexbuf; token lexbuf }
  | print        { incr_bol lexbuf 5; Buffer.add_char buffer '"'; PRINT }
  | sleep        { incr_bol lexbuf 5; SLEEP }
  | '"'          { incr_bol lexbuf 1; Buffer.reset buffer; str_rule buffer lexbuf }
  | ''' | rem    { incr_bol lexbuf 1; Buffer.reset buffer; Buffer.add_string buffer "//"; comment buffer lexbuf }
  | cond         { incr_bol lexbuf 2; Buffer.reset buffer; statement buffer lexbuf }
  | eof          { EOF }

  (* Skip white spaces *)
  | ' ' | '\t' | '\r' | '\n' { token lexbuf }
  (* Raise an exception with all unknown characters *)
  | _ as c { Errors.error ("Unrecognized character: " ^ (string_of_char c)) lexbuf.lex_curr_p }
and str_rule buffer = parse
  | '"'      { incr_bol lexbuf 1; next_str buffer lexbuf }
  | '\n'     { incr_bol lexbuf 2; Buffer.add_char buffer '\\'; Buffer.add_char buffer 'n'; incr_line lexbuf; str_rule buffer lexbuf }
  | _ as lxm { incr_bol lexbuf 1; Buffer.add_char buffer lxm; str_rule buffer lexbuf }
and next_str buffer = parse
  | '"'      { incr_bol lexbuf 1; str_rule buffer lexbuf }
  | '\n'     { Buffer.add_char buffer '\\'; Buffer.add_char buffer 'n'; Buffer.add_char buffer '"'; incr_line lexbuf; STRING (Buffer.contents buffer) }
  | _        { incr_bol lexbuf 1; next_str buffer lexbuf }
and comment buffer = parse
  | '\n'           { incr_bol lexbuf 2; COMMENT (Buffer.contents buffer)  }
  | _ as lxm       { incr_bol lexbuf 1; Buffer.add_char buffer lxm; comment buffer lexbuf }
and statement buffer = parse
  | mthen {  }
  
{}
