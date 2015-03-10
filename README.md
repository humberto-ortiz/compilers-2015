# compilers-2015
Example code for compilers class.

You will need a copy of the example code from the textbook also.

http://www.cs.princeton.edu/~appel/modern/ml/project.html

Code for example problems

 maxargs.sml - a modified exercise, count the maximum number of
 arguments in any constructor for straight line programs. My version
 is buggy. You need to fix it.

 interp.sml - half of a working interpreter for straight line
 programs. You need to implement update and the rest of interpexp and
 interpstm.

 parser/ - a nearly correct parser and interpreter for straight line programs.
 See the README for usage instructions. You need to fix some shift/reduce
 conflicts.
 
 tiger-parser/ - A skeleton parser for tiger, using the code from
 Chapter 3 and the examples we did in class today. I added SEMICOLON,
 so you can write longer test programs (like all.tig).
