type bas = string
type t_prog = 
        /*empty*/
        | t_inst * t_prog
type t_inst =
        | Print of string
        | If of string * t_inst list * t_inst list
