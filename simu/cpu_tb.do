vlib work

vcom -93 ../src/mux21.vhd
vcom -93 ../src/signed_extension.vhd
vcom -93 ../src/memory.vhd
vcom -93 ../src/psr.vhd
vcom -93 ../src/register_bench.vhd
vcom -93 ../src/alu.vhd
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/instruction_handler.vhd
vcom -93 ../src/instruction_decoder.vhd
vcom -93 ../src/processing_unit.vhd
vcom -93 ../src/cpu.vhd
vcom -93 ../tests/cpu_tb.vhd

vsim cpu_tb

add wave /*

run -a
