vlib work

vcom -2008 ../src/mux21.vhd
vcom -2008 ../src/signed_extension.vhd
vcom -2008 ../src/memory.vhd
vcom -2008 ../src/psr.vhd
vcom -2008 ../src/register_bench.vhd
vcom -2008 ../src/alu.vhd
vcom -2008 ../src/instruction_memory.vhd
vcom -2008 ../src/instruction_handler.vhd
vcom -2008 ../src/instruction_decoder.vhd
vcom -2008 ../src/processing_unit.vhd
vcom -2008 ../src/cpu.vhd
vcom -2008 ../tests/cpu_tb3.vhd

vsim cpu_tb

add wave /*

run -a
