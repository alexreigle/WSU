restart -f -nowave

add wave increment
add wave reset
add wave clock
add wave out

force clock 0 0, 1 1 -r 2
force increment 0 0, 1 2 -r 4
force reset 1 0, 0 50, 1 60

run 96