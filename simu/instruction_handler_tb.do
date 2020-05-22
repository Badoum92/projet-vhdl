vlib work

vcom -93 ../src/mux21.vhd
vcom -93 ../src/signed_extension.vhd
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/instruction_handler.vhd
vcom -93 ../tests/instruction_handler_tb.vhd

vsim instruction_handler_tb

add wave /*

run -a
