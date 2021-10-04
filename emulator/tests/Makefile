test: test-138

test-138: tb_138.vvp
	vvp $<

TB138SRC=../chips/demux_138.v testhelpers.v tb_138.v

tb_138.vvp: $(TB138SRC)
	iverilog $(TB138SRC) -o $@

clean:
	rm -f *.vvp
