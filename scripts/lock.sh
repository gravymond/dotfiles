#!/bin/sh

B='#00000000'  # blank
C='#ffffff22'  # clear ish
D='#30a06666'  # default
T='#30a066ff'  # text
W='#a03030bb'  # wrong
V='#c1aa13bb'  # verifying

exec i3lock \
--insidevercolor=$C   \
--ringvercolor=$V     \
\
--insidewrongcolor=$C \
--ringwrongcolor=$W   \
\
--insidecolor=$B      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T        \
--layoutcolor=$T      \
--keyhlcolor=$W       \
--bshlcolor=$W        \
\
--screen 1            \
--blur 5              \
--clock               \
--radius 120
--indicator           \
--timestr="%H:%M:%S"  \
--datestr="%A, %m %Y" \
# --keylayout 2         \
--veriftext="Drinking verification can..."
--wrongtext="Nope!"
--textsize=20
# --modsize=10
 --timefont=hack
 --datefont=hack
# etc