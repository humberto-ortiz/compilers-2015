Parser to read tiger programs and produce an abstract syntax
tree. Based on the parser in Chapter 4, I added 3 new expression types
so I can parse a simple program:

plus.tig
```
3 + "Hello"
```

Running the parser:
```
- Parse.parse "plus.tig";
val it = OpExp {left=IntExp 3,oper=PlusOp,pos=2,right=StringExp ("Hello",6)}
  : Absyn.exp
- 
```
