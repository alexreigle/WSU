restart -f -nowave
add wave A
add wave B
add wave C
add wave D
add wave F

force A 0 0, 1 1 -r 2
force B 0 0, 1 2 -r 4
force C 0 0, 1 4 -r 8
force D 0 0, 1 8 -r 16

run 32