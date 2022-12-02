restart -f -nowave
add wave clk
add wave reset
add wave D
add wave hamm
add wave increment

force clk 0 0, 1 1 -r 2
force increment 1 0
force reset 1 0, 0 1, 1 2 -r 56
force hamm 1 0, 0 3, 1 54 
run 56
force increment 1 0, 0 4 -r 6
run 100