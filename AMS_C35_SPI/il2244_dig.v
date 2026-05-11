`ifndef IL2244_DIG_V
`define IL2244_DIG_V

`include "il2244_spi.v"

module il2244_dig (
			input reset_l, // Reset async. (L)
            input porborn, //Power-on-Reset/Brown-out-Reset (L)
			input SPI_CS, // chip select  (L)
			input SPI_Clk, // Mode 0, data is sampled at the rising edge
			input SPI_MOSI, // Master output  Slave Input		
			output [2:0] fECG_filter,  // control fECG GMC filter bandwidth
            output [2:0] fECG_gain, // Controls the fECG variable gain
            output fECG_BG_sel, // Control fECG selection of external/internal bandgap
            output [5:0] potentiostat, // Copntrols the gain of the potentiostat
            output [2:0] ECG_filter,  // control ECG GMC filter bandwidth
            output [3:0] ECG_gain, // Controls the fECG variable gain
            output ECG_BG_sel // Control the ECG selection of external/internal bandgap
            ); 
 

    /**********************************************/
    /* Configuration words bit mapping            */
    /*                                            */
    /* conf0:                                     */
    /*                                            */
    /* bits 2-0: [2:0] fECG_filter                */
    /* bits 5-3: [2:0] fECG_gain                  */
    /* bits 6:   fECG_BG_sel                      */
    /* bits 12-7:  [5:0] potentiostat                    */
    /*                                            */
    /* conf1:                                     */
    /*                                            */
    /* bits 9-0: [9:0] ramp_factor                */
    /* bits 19-10: [9:0] OFF_time                 */
    /* bit 22: enable                             */
    /* bits 23-21: [2:0] phaseDuration            */
    /*                                            */
    /**********************************************/

    wire resetn;

    wire [31:0] conf0;
	wire [31:0] conf1;

    assign resetn = reset_l & porborn;

    il2244_spi spi (
        .resetn(resetn),
        .SPI_CS(SPI_CS),
        .SPI_Clk(SPI_Clk),
        .SPI_MOSI(SPI_MOSI),
        .conf0(conf0),
        .conf1(conf1)
    );

    // Map conf0 to the respective outputs
    assign fECG_filter = conf0[2:0];
    assign fECG_gain = conf0[5:3];
    assign fECG_BG_sel = conf0[6];
    assign potentiostat = conf0[12:7];

    // Map conf1 to the respective outputs
    assign ECG_filter = conf1[2:0]; // Assuming bits 2-0 for ECG_filter
    assign ECG_gain = conf1[6:3];   // Assuming bits 6-3 for ECG_gain
    assign ECG_BG_sel = conf1[7];   // Assuming bit 7 for ECG_BG_sel

endmodule

`endif



