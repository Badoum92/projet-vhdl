vlib work

vcom -93 ../src/alu.vhd
vcom -93 ../src/register_bench.vhd
vcom -93 ../src/memory.vhd
vcom -93 ../src/mux21.vhd
vcom -93 ../src/signed_extension.vhd
vcom -93 ../tests/part1_tb.vhd

vsim part1_tb

add wave /*

run -a
