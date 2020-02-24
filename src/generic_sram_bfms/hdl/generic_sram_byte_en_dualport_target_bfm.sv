/****************************************************************************
 * generic_sram_byte_en_dualport_target_bfm
 * 
 * Implements a target BFM for a dual-port SRAM with byte enabled writes.
 ****************************************************************************/

module generic_sram_byte_en_dualport_target_bfm #(
		parameter DATA_WIDTH		= 32,
		parameter ADDRESS_WIDTH		= 8,
		parameter INIT_FILE			= ""
		) (
		input						i_clk,
		input[DATA_WIDTH-1:0]		i_write_data_a,
		input						i_write_enable_a,
		input [ADDRESS_WIDTH-1:0]	i_address_a,
		input [DATA_WIDTH/8-1:0]	i_byte_enable_a,
		output[DATA_WIDTH-1:0]		o_read_data_a,
		
		input[DATA_WIDTH-1:0]		i_write_data_b,
		input						i_write_enable_b,
		input [ADDRESS_WIDTH-1:0]	i_address_b,
		input [DATA_WIDTH/8-1:0]	i_byte_enable_b,
		output[DATA_WIDTH-1:0]		o_read_data_b
		);
	
	reg [DATA_WIDTH-1:0]   mem  [0:2**ADDRESS_WIDTH-1];
	
	initial begin
		if (INIT_FILE != "") begin
			$display("Initializing SRAM %m from %s", INIT_FILE);
			$readmemh(INIT_FILE, mem);
		end
	end
	
	// read
	assign o_read_data_a = i_write_enable_a ? {DATA_WIDTH{1'd0}} : mem[i_address_a];
	//	genvar j;

	//	generate
	//	genvar i;
	//	integer i;
	always @(posedge i_clk) begin : WRITE
		integer i;

		// write
		for (i=0;i<DATA_WIDTH/8;i=i+1) begin : mw
			if (i_write_enable_a) begin
				mem[i_address_a][i*8+0] = i_byte_enable_a[i] ? i_write_data_a[i*8+0] : mem[i_address_a][i*8+0] ;
				mem[i_address_a][i*8+1] = i_byte_enable_a[i] ? i_write_data_a[i*8+1] : mem[i_address_a][i*8+1] ;
				mem[i_address_a][i*8+2] = i_byte_enable_a[i] ? i_write_data_a[i*8+2] : mem[i_address_a][i*8+2] ;
				mem[i_address_a][i*8+3] = i_byte_enable_a[i] ? i_write_data_a[i*8+3] : mem[i_address_a][i*8+3] ;
				mem[i_address_a][i*8+4] = i_byte_enable_a[i] ? i_write_data_a[i*8+4] : mem[i_address_a][i*8+4] ;
				mem[i_address_a][i*8+5] = i_byte_enable_a[i] ? i_write_data_a[i*8+5] : mem[i_address_a][i*8+5] ;
				mem[i_address_a][i*8+6] = i_byte_enable_a[i] ? i_write_data_a[i*8+6] : mem[i_address_a][i*8+6] ;
				mem[i_address_a][i*8+7] = i_byte_enable_a[i] ? i_write_data_a[i*8+7] : mem[i_address_a][i*8+7] ;
			end
		end
	end
	//	 endgenerate
    
	assign o_read_data_b = i_write_enable_b ? 
		{DATA_WIDTH{1'd0}} : 
		mem[i_address_b];

	generate
		integer j;
		always @(posedge i_clk) begin
			// read

			// write
			if (i_write_enable_b) begin
				for (j=0;j<DATA_WIDTH/8;j=j+1) begin
					mem[i_address_b][j*8+0] = i_byte_enable_b[j] ? i_write_data_b[j*8+0] : mem[i_address_b][j*8+0] ;
					mem[i_address_b][j*8+1] = i_byte_enable_b[j] ? i_write_data_b[j*8+1] : mem[i_address_b][j*8+1] ;
					mem[i_address_b][j*8+2] = i_byte_enable_b[j] ? i_write_data_b[j*8+2] : mem[i_address_b][j*8+2] ;
					mem[i_address_b][j*8+3] = i_byte_enable_b[j] ? i_write_data_b[j*8+3] : mem[i_address_b][j*8+3] ;
					mem[i_address_b][j*8+4] = i_byte_enable_b[j] ? i_write_data_b[j*8+4] : mem[i_address_b][j*8+4] ;
					mem[i_address_b][j*8+5] = i_byte_enable_b[j] ? i_write_data_b[j*8+5] : mem[i_address_b][j*8+5] ;
					mem[i_address_b][j*8+6] = i_byte_enable_b[j] ? i_write_data_b[j*8+6] : mem[i_address_b][j*8+6] ;
					mem[i_address_b][j*8+7] = i_byte_enable_b[j] ? i_write_data_b[j*8+7] : mem[i_address_b][j*8+7] ;
				end
			end
		end
	endgenerate	

	/**
	 * Task: init
	 * 
	 * Task description needed
	 * 
	 * Parameters:
	 */
	task init();
		$display("bfm_initialize");
		set_parameters(DATA_WIDTH, ADDRESS_WIDTH);
	endtask

	/**
	 * Task: _read_req
	 * 
	 * Implements the back-door read operation
	 * 
	 * Parameters:
	 * - bit addr 
	 */
	task _read_req(bit[31:0] addr);
		_read_ack(mem[addr]);
	endtask

	/**
	 * Task: _write_req
	 * 
	 * Implements the back-door write operation. 
	 * 
	 * Parameters:
	 * - bit addr 
	 * - bit data 
	 * - bit byte_en 
	 */
	task _write_req(bit[31:0] addr, bit[63:0] data, bit[15:0] byte_en);
		begin
		for (int i=0; i<DATA_WIDTH/8; i=i+1) begin
			mem[addr][i*8+0] = byte_en[i] ? data[i*8+0] : mem[addr][i*8+0];
			mem[addr][i*8+1] = byte_en[i] ? data[i*8+1] : mem[addr][i*8+1];
			mem[addr][i*8+2] = byte_en[i] ? data[i*8+2] : mem[addr][i*8+2];
			mem[addr][i*8+3] = byte_en[i] ? data[i*8+3] : mem[addr][i*8+3];
			mem[addr][i*8+4] = byte_en[i] ? data[i*8+4] : mem[addr][i*8+4];
			mem[addr][i*8+5] = byte_en[i] ? data[i*8+5] : mem[addr][i*8+5];
			mem[addr][i*8+6] = byte_en[i] ? data[i*8+6] : mem[addr][i*8+6];
			mem[addr][i*8+7] = byte_en[i] ? data[i*8+7] : mem[addr][i*8+7];
		end
		
		_write_ack();
		end
	endtask
	
	// Auto-generated code to implement the BFM API
${pybfms_api_impl}
	
endmodule
