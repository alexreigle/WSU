transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jehan/Desktop/2022\ Fall/CEG\ 7360 {C:/Users/jehan/Desktop/2022 Fall/CEG 7360/Exam.v}
vlog -vlog01compat -work work +incdir+C:/Users/jehan/Desktop/2022\ Fall/CEG\ 7360 {C:/Users/jehan/Desktop/2022 Fall/CEG 7360/Problem2.v}

