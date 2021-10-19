GPREGSRC=../cpu-modules/gp_register.v ../chips/dff_173.v ../chips/buffer_245.v
ALUADDSUBSRC=../cpu-modules/alu_addsub.v ../chips/buffer_245.v ../chips/adder_283.v ../chips/xor_86b.v ../chips/xor_86p.v ../chips/and_08p.v ../chips/buffer_125p.v
FLGREGSRC=../cpu-modules/flags_reg.v ../chips/dff_173.v ../chips/nor_02b.v ../chips/and_08p.v ../chips/mux_157b.v ../chips/buffer_125p.v
ALUBLOCKSRC=../cpu-modules/alu_block.v $(GPREGSRC) $(ALUADDSUBSRC) $(FLGREGSRC) ../chips/demux_138.v
CPUSRC=../cpu-modules/cpu.v $(ALUBLOCKSRC)