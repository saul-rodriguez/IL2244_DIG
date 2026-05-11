#NAME is the name of the top_module which should be inside the file top_module.v

SRC = il2244_dig.v
SRC_TB = il2244_dig_tb.v
NAME= $(basename $(SRC))

sim: $(NAME)

$(NAME): $(SRC_TB)
	iverilog -g2005-sv -o $(NAME) $(SRC_TB)
	vvp $(NAME)

plot: $(NAME) dump.vcd
	gtkwave dump.vcd

bit: $(SRC_TB)
	@echo Synthetize	
	#yosys -p 'synth_ice40 -top $(NAME) -blif $(NAME).blif' $(SRC)
	yosys -p 'synth_ecp5 -top $(NAME) -json $(NAME).json' $(SRC)
	@echo Place and Route
	#arachne-pnr -d 8k -P cm81 -o $(NAME).asc -p pins.pcf $(NAME).blif
	nextpnr-ecp5 --85k --json top.json --lpf ulx3s_v20.lpf --textcfg ulx3s_out.config --package CABGA381
	@echo bitfile
	#icepack $(NAME).asc $(NAME).bin
	ecppack ulx3s_out.config ulx3s.bit



#time: 	$(NAME).asc
	#icetime -d lp8k -mtr $(NAME).rpt $(NAME).asc
	

#upload: $(NAME).bin
upload: ulx3s.bit
	#tinyprog -p $(NAME).bin
	fujprog ulx3s.bit
clean: 
	rm -rf $(NAME) *.bit *.config *.json *.vcd
	

