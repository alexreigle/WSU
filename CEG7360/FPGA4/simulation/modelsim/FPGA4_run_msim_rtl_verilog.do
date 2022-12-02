transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jehan/Desktop/2022\ Fall/CEG\ 7360 {C:/Users/jehan/Desktop/2022 Fall/CEG 7360/Lab4FPGA.v}
vlog -vlog01compat -work work +incdir+C:/Users/jehan/Desktop/2022\ Fall/CEG\ 7360 {C:/Users/jehan/Desktop/2022 Fall/CEG 7360/FPGA4.v}
vlog -vlog01compat -work work +incdir+C:/Users/jehan/Desktop/2022\ Fall/CEG\ 7360 {C:/Users/jehan/Desktop/2022 Fall/CEG 7360/counter.v}

