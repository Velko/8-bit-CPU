GPREGSRC=../cpu-modules/gp_register.v ../chips/dff_173.v ../chips/buffer_245.v
ALUADDSUBSRC=../cpu-modules/alu_addsub.v ../chips/buffer_245.v ../chips/adder_283.v ../chips/xor_86b.v ../chips/xor_86p.v ../chips/and_08p.v ../chips/buffer_125p.v
ALUANDORSRC=../cpu-modules/alu_andor.v ../chips/buffer_245.v ../chips/and_08b.v ../chips/or_32b.v ../chips/mux_157b.v
ALUXORNOTSRC=../cpu-modules/alu_xornot.v ../chips/buffer_245.v ../chips/xor_86b.v ../chips/or_32b.v
ALUSHIFTSWAPSRC=../cpu-modules/alu_shiftswap.v ../chips/buffer_245.v ../chips/mux_157b.v ../chips/buffer_125p.v
FLGREGSRC=../cpu-modules/flags_reg.v ../chips/dff_173.v ../chips/nor_02b.v ../chips/and_08p.v ../chips/mux_157b.v ../chips/buffer_125p.v
PCSRC=../cpu-modules/program_counter.v ../chips/dff_173.v ../chips/counter_161.v
SPSRC=../cpu-modules/stack_pointer.v ../chips/dff_173.v ../chips/udcounter_193.v ../chips/or_32p.v ../chips/not_04p.v
MEMSRC=../cpu-modules/memory.v ../chips/ram_62256.v ../chips/nand_00p.v ../chips/buffer_245.v
IREGSRC=../cpu-modules/i_register.v ../chips/dff_173.v
TXREGSRC=../cpu-modules/tx_register.v ../chips/dff_173.v ../chips/mux_157b.v ../chips/buffer_245.v ../chips/and_08p.v
ACALSRC=../cpu-modules/address_calc.v ../chips/dff_173.v ../chips/adder_283.v ../chips/buffer_245.v
IOCTLSRC=../cpu-modules/io_control.v ../chips/dff_173.v ../chips/demux_138.v ../chips/buffer_245.v
CTRLSRC=../cpu-modules/control_logic.v ../chips/counter_161.v ../chips/dff_74.v ../chips/nand_00p.v
CLOCKSRC=../cpu-modules/clock.v ../chips/dff_74.v ../chips/nand_00p.v ../chips/nor_02p.v ../chips/xor_86p.v
ALUBLOCKSRC=../cpu-modules/alu_block.v $(GPREGSRC) $(ALUADDSUBSRC) $(ALUANDORSRC) $(ALUXORNOTSRC) $(ALUSHIFTSWAPSRC) $(FLGREGSRC) ../chips/demux_138.v
MEMBLOCKSRC=../cpu-modules/mem_block.v $(PCSRC) $(MEMSRC) $(IREGSRC) $(TXREGSRC) $(SPSRC) $(ACALSRC) ../chips/demux_138.v
IOBLOCKSRC=../cpu-modules/io_block.v $(IOCTLSRC) ../chips/demux_138.v ../cpu-modules/display_num.v ../cpu-modules/display_char.v ../cpu-modules/display_lcd.v
CPUSRC=../cpu-modules/cpu.v ../cpu-modules/cword_splitter.v $(ALUBLOCKSRC) $(MEMBLOCKSRC) $(CTRLSRC) $(IOBLOCKSRC)

VPATH=../cpu-modules
control_rom.vpi: control_words.c microcode.c
	iverilog-vpi --name=control_rom $^