vlib work

vcom -93 ../src/alu.vhd
vcom -93 ../src/register_bench.vhd
vcom -93 ../tests/alu_regbench_tb.vhd

vsim ALU_REGBENCH_TB

add wave /*

run -a
