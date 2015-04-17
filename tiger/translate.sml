signature TRANSLATE =
sig
    type level
    type access

    val outermost: level
    val newLevel: {parent: level, name: Temp.label,
		  formals: bool list} -> level
    val formals: level -> access list
    val allocLocal: level -> bool -> access
end
(* dummy translate for chapter 5 *)
structure Translate : TRANSLATE = 
struct 
    type exp = unit 
    type level = int 
    type access = level * Frame.access
    val outermost = 0
    fun newLevel {parent, name, formals} = parent + 1
    fun formals level = [(0, 0)]
    fun allocLocal level = (fn x: bool => (0,0))
end
