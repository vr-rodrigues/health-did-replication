#!/bin/bash
# Promote LaTeX headings one level up using placeholders so substitutions
# don't cascade:
#   \chapter{X}       -> \section{X}
#   \section{X}       -> \subsection{X}
#   \subsection{X}    -> \subsubsection{X}
#   \subsubsection{X} -> \paragraph{X}
# Starred forms preserved (\chapter*{X} -> \section*{X}, etc.).
# Reads from $1, writes to $2.
in="$1"
out="$2"
sed -E \
  -e 's/\\subsubsection\*/__L4STAR__/g' \
  -e 's/\\subsubsection\{/__L4__\{/g' \
  -e 's/\\subsection\*/__L3STAR__/g' \
  -e 's/\\subsection\{/__L3__\{/g' \
  -e 's/\\section\*/__L2STAR__/g' \
  -e 's/\\section\{/__L2__\{/g' \
  -e 's/\\chapter\*/__L1STAR__/g' \
  -e 's/\\chapter\{/__L1__\{/g' \
  -e 's/__L1__/\\section/g' \
  -e 's/__L1STAR__/\\section*/g' \
  -e 's/__L2__/\\subsection/g' \
  -e 's/__L2STAR__/\\subsection*/g' \
  -e 's/__L3__/\\subsubsection/g' \
  -e 's/__L3STAR__/\\subsubsection*/g' \
  -e 's/__L4__/\\paragraph/g' \
  -e 's/__L4STAR__/\\paragraph*/g' \
  "$in" > "$out"
