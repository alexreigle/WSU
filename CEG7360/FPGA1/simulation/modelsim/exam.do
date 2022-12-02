restart -f nowave

add wave reset
add wave increment
add wave data

force reset 1 0 , 0 5
force increment 0 0, 1 1 -r 2

run 21