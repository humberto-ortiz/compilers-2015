# Try to grok first
# Copyright 2015 - Humberto Ortiz-Zuazaga <humberto.ortiz@upr.edu>

#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License along
#    with this program; if not, write to the Free Software Foundation, Inc.,
#    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

from collections import defaultdict

# Encode the grammar as a series of lines X->ABc
# Capital letters are non-terminals
# lowercase are terminals
# no spaces
# ~ is epsilon

productions = """A->a
B->b
S->ASB
S->~"""

# Look over the productions, construct sets of terminals and non-terminals
terminals = set()
nonterminals = set()

for symbol in productions:
    # lowercase letters are terminal symbols
    if symbol.isupper():
        nonterminals.update(symbol)
    # uppercase letters are non-terminal symbols
    if symbol.islower():
        terminals.update(symbol)

print nonterminals, terminals

# start the algorithm

# first is a dictionary of empty sets
first = defaultdict(set)

# add the terminals to their own first sets
for symbol in terminals:
    first[symbol].update(symbol)

# epsilon is the tilde
first["~"].update("~")

# fixed point iteration
for i in range(len(nonterminals)):
    for symbol in nonterminals:
        for line in productions.split():

            X = line[0]
            if X == symbol:
                Y = line[3:] # skip "->"

                if Y[0] == '~':
                    # X derives epsilon
                    first[X].update("~")

                first[X].update(first[Y[0]] - set("~") )

                # if prefix of Y is nullable
                for j in range(len(Y) - 1):
                    nullable = 0
                    for i in range(j-1):
                        if "~" in first[Y[j]]:
                            nullable = 1
                        else:
                            nullable = 0
                            break
                    if nullable:
                        first[X].update(first[Y[j+1]] - set("~"))

# We should be done now
for symbol in sorted(nonterminals):
    print symbol, first[symbol]
