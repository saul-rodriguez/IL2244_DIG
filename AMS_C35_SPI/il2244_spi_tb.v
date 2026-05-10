`include "il2244_spi.v"

`timescale 1us/ 1ps

module DIG_stimulus(
    output reg SPI_Clk,
	output reg SPI_MOSI,
	output reg SPI_CS,
	output reg reset_l);

    reg [7:0] TX_data; // Data to send through MOSI	

    wire [31:0] conf0;
	wire [31:0] conf1;

    parameter SPI_CLK_DELAY = 1; // 500 kHz

    il2244_spi il2244_spi_UUT
		(			
			.resetn(reset_l),
			.SPI_CS(SPI_CS),
			.SPI_Clk(SPI_Clk),
			.SPI_MOSI(SPI_MOSI),			 
			.conf0(conf0),
			.conf1(conf1)
        );

    initial begin
        // Required for EDA Playground
		$dumpfile("dump.vcd"); 
		$dumpvars;
		$display("******************************************");
		$display("Test ASKA SPI Slave");

        TX_data = 8'h00;
		reset_l = 1'b1;		
		SPI_CS = 1'b1;
		SPI_Clk = 1'b0;
		SPI_MOSI = 1'b0;

        //Reset
		#(10*SPI_CLK_DELAY) reset_l = 1'b0;
		#(10*SPI_CLK_DELAY) reset_l = 1'b1;
		#(10*SPI_CLK_DELAY);

		// Change conf0
        send_SPI(8'h00,32'haabbccdd);

		// Change conf1
        send_SPI(8'h01,32'hccaaeeff);

		// Send wrong address
        send_SPI(8'h02,32'h55aadd22);

		// Send wrong number of bytes
        send_SPI_error(8'h01,32'h11223344);

		// Change conf0 again
        send_SPI(8'h00,32'hbbeeccaa);

        #(100*SPI_CLK_DELAY); 
		$display("******************************************");		
		$finish;

        
    end

	reg[8*6:1] str1;

    task send_SPI(input [7:0] add, input [31:0] data);
		begin
			SPI_CS = 1'b0;
			#(4*SPI_CLK_DELAY); // models delay between CS and SPI master data
			
			send_byte(add);
			send_byte(data[31:24]);
			send_byte(data[23:16]);
			send_byte(data[15:8]);
			send_byte(data[7:0]);
			
			#(4*SPI_CLK_DELAY); // models delay between CS and SPI master 
			SPI_CS = 1'b1;	
			
			//Check values
			#(4*SPI_CLK_DELAY);

			$display("sent SPI add 0x%X, data 0x%X at time:",add, data, $time);
			

			case (add)
				8'h00:  	begin
								str1 = (data == conf0)? "OK" : "ERROR";
								$display("sent conf0 0x%X, register conf0 0x%X, %s", data, conf0, str1);
							end
				8'h01: 		begin
								str1 = (data == conf1)? "OK" : "ERROR";
								$display("sent conf1 0x%X, register conf0 0x%X, %s", data, conf1, str1);
							end
				default:	begin
								$display(" 					ERROR WRONG ADDRESS");
							end

			endcase

			$display("conf0 = 0x%X ",conf0);
			$display("conf1 = 0x%X ",conf1);

			
		end
	endtask
	
	// This function sends an incomplete word of 32 bits instead of 40
	task send_SPI_error(input [7:0] add, input [31:0] data);
		begin
			$display("ERROR TEST: SENDING INCOMPLETE WORD");
			SPI_CS = 1'b0;
			#(4*SPI_CLK_DELAY); // models delay between CS and SPI master data
			
			send_byte(add);
			send_byte(data[31:24]);
			send_byte(data[23:16]);
			//send_byte(data[15:8]);
			send_byte(data[7:0]);
			
			#(4*SPI_CLK_DELAY); // models delay between CS and SPI master 
			SPI_CS = 1'b1;	
			
			//Check values
			#(4*SPI_CLK_DELAY);

			$display("sent SPI add 0x%X, data 0x%X at time:",add, data, $time);
			

			case (add)
				8'h00:  	begin
								str1 = (data == conf0)? "OK" : "ERROR";
								$display("sent conf0 0x%X, register conf0 0x%X, %s", data, conf0, str1);
							end
				8'h01: 		begin
								str1 = (data == conf1)? "OK" : "ERROR";
								$display("sent conf1 0x%X, register conf0 0x%X, %s", data, conf1, str1);
							end
				default:	begin
								$display("Wrong address, 					ERROR");
							end

			endcase

			$display("conf0 = 0x%X ",conf0);
			$display("conf1 = 0x%X ",conf1);			
		end
	endtask

    task send_byte(input [7:0] data);
		begin
			TX_data = data;			

			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[7];
						
			#SPI_CLK_DELAY;		
			SPI_Clk = 1'b1;
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[6];
		
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;			
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[5];
				
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[4];

			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[3];
		
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;			
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[2];

			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;			
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[1];

			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;			
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
			SPI_MOSI = TX_data[0];
		
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b1;
			
			#SPI_CLK_DELAY;
			SPI_Clk = 1'b0;
						
		end
	endtask

endmodule 