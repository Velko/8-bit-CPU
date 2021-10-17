test: test-138 test-161-basics test-161-chaining test-245 test-173 test-283 test-86b test-86p \
      test-08b test-08p test-02b test-02p test-157b test-125p \
      test-gp-register test-alu-addsub test-flags-reg test-alu-block

print:
	echo $(addprefix tb_,$(addsuffix .vvp,$(subst -,_, $(BENCHES))))

test-%: tb_%.vvp
	@vvp $<


TB138SRC=../chips/demux_138.v testhelpers.v tb_138.v

tb_138.vvp: $(TB138SRC)
	iverilog -Wall $^ -o $@


TB161BASICSRC=../chips/counter_161.v testhelpers.v tb_161_basics.v

tb_161-basics.vvp: $(TB161BASICSRC)
	iverilog -Wall $^ -o $@


TB161CHAINSRC=../chips/counter_161.v testhelpers.v tb_161_chaining.v

tb_161-chaining.vvp: $(TB161CHAINSRC)
	iverilog -Wall $^ -o $@


TB245SRC=../chips/buffer_245.v testhelpers.v tb_245.v

tb_245.vvp: $(TB245SRC)
	iverilog -Wall $^ -o $@

TB173SRC=../chips/dff_173.v testhelpers.v tb_173.v

tb_173.vvp: $(TB173SRC)
	iverilog -Wall $^ -o $@

TB283SRC=../chips/adder_283.v testhelpers.v tb_283.v

tb_283.vvp: $(TB283SRC)
	iverilog -Wall $^ -o $@


TB86BSRC=../chips/xor_86b.v testhelpers.v tb_86b.v

tb_86b.vvp: $(TB86BSRC)
	iverilog -Wall $^ -o $@

TB86PSRC=../chips/xor_86p.v testhelpers.v tb_86p.v

tb_86p.vvp: $(TB86PSRC)
	iverilog -Wall $^ -o $@

TB08BSRC=../chips/and_08b.v testhelpers.v tb_08b.v

tb_08b.vvp: $(TB08BSRC)
	iverilog -Wall $^ -o $@

TB08PSRC=../chips/and_08p.v testhelpers.v tb_08p.v

tb_08p.vvp: $(TB08PSRC)
	iverilog -Wall $^ -o $@


TB02BSRC=../chips/nor_02b.v testhelpers.v tb_02b.v

tb_02b.vvp: $(TB02BSRC)
	iverilog -Wall $^ -o $@

TB02PSRC=../chips/nor_02p.v testhelpers.v tb_02p.v

tb_02p.vvp: $(TB02PSRC)
	iverilog -Wall $^ -o $@

TB157BSRC=../chips/mux_157b.v testhelpers.v tb_157b.v

tb_157b.vvp: $(TB157BSRC)
	iverilog -Wall $^ -o $@


TB125PSRC=../chips/buffer_125p.v testhelpers.v tb_125p.v

tb_125p.vvp: $(TB125PSRC)
	iverilog -Wall $^ -o $@


GPREGSRC=../chips/dff_173.v ../chips/buffer_245.v ../cpu-modules/gp_register.v
TBGPREGSRC=$(GPREGSRC) testhelpers.v tb_gp_register.v

tb_gp-register.vvp: $(TBGPREGSRC)
	iverilog -Wall $^ -o $@

ALUADDSUBSRC=../chips/buffer_245.v ../chips/adder_283.v ../chips/xor_86b.v ../chips/xor_86p.v ../chips/and_08p.v ../chips/buffer_125p.v ../cpu-modules/alu_addsub.v
TBALUADDSUBSRC=$(ALUADDSUBSRC) testhelpers.v tb_alu_addsub.v

tb_alu-addsub.vvp: $(TBALUADDSUBSRC)
	iverilog -Wall $^ -o $@


FLGREGSRC=../chips/dff_173.v ../chips/nor_02b.v ../chips/and_08p.v ../chips/mux_157b.v ../chips/buffer_125p.v ../cpu-modules/flags_reg.v
TBFLGREGSRC=$(FLGREGSRC) testhelpers.v tb_flags_reg.v

tb_flags-reg.vvp: $(TBFLGREGSRC)
	iverilog -Wall $^ -o $@

ALUBLOCKSRC=$(GPREGSRC) $(ALUADDSUBSRC) $(FLGREGSRC) ../cpu-modules/alu_block.v
TBALUBLOCKSRC=$(ALUBLOCKSRC) testhelpers.v tb_alu_block.v

tb_alu-block.vvp: $(TBALUBLOCKSRC)
	iverilog -Wall $^ -o $@


clean:
	rm -f *.vvp
