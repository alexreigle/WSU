restart -f -nowave

add wave enable
add wave reset
add wave clock
add wave count

force enable 1 0, 0 64
force reset 1 0, 0 35, 1 40, 0 80
force clock 0 0, 1 1 -r 2

run 90