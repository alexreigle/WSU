restart -f -nowave

add wave clock
add wave increment
add wave reset
add wave data

force clock 0 0, 1 1 -r 2
force increment 0 0, 1 2 -r 38
force reset 0 0, 1 39, 0 40

run 50