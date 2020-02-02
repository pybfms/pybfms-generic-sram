

module generic_sram_byte_en_dualport_target_bfm #(
		parameter DATA_WIDTH		= 32,
		parameter ADDRESS_WIDTH		= 8,
		parameter INIT_FILE			= ""
		) (
		input						i_clk,
		output[DATA_WIDTH-1:0]		i_write_data_a,
		input [ADDRESS_WIDTH-1:0]	i_address_a,
		input [DATA_WIDTH/8-1:0]	i_byte_enable_a,
		output[DATA_WIDTH-1:0]		o_read_data
		);

	reg [DATA_WIDTH-1:0]    	mem  [0:2**ADDRESS_WIDTH-1];
	reg [DATA_WIDTH-1:0]		read_data_r;
	reg [ADDRESS_WIDTH-1:0]		address_r;
	reg [DATA_WIDTH-1:0]		write_data_r;
	reg 						write_enable_r;
	reg [DATA_WIDTH/8-1:0]		byte_enable_r;
	integer i;
	
	assign o_read_data = read_data_r;
	
	initial begin
		if (INIT_FILE != "") begin
			$display("Note: Initializing SRAM %m from %s", INIT_FILE);
			$readmemh(INIT_FILE, mem);
		end
	end	
	
	always @(posedge i_clk) begin
		// read
		address_r 		<= i_address;
		write_data_r 	<= i_write_data;
		write_enable_r	<= i_write_enable;
		byte_enable_r	<= i_byte_enable;
    
		read_data_r <= mem[address_r];

		// write
		if (write_enable_r) begin
			for (i=0;i<DATA_WIDTH/8;i=i+1) begin
				mem[address_r][i*8+0] = byte_enable_r[i] ? write_data_r[i*8+0] : mem[address_r][i*8+0] ;
				mem[address_r][i*8+1] = byte_enable_r[i] ? write_data_r[i*8+1] : mem[address_r][i*8+1] ;
				mem[address_r][i*8+2] = byte_enable_r[i] ? write_data_r[i*8+2] : mem[address_r][i*8+2] ;
				mem[address_r][i*8+3] = byte_enable_r[i] ? write_data_r[i*8+3] : mem[address_r][i*8+3] ;
				mem[address_r][i*8+4] = byte_enable_r[i] ? write_data_r[i*8+4] : mem[address_r][i*8+4] ;
				mem[address_r][i*8+5] = byte_enable_r[i] ? write_data_r[i*8+5] : mem[address_r][i*8+5] ;
				mem[address_r][i*8+6] = byte_enable_r[i] ? write_data_r[i*8+6] : mem[address_r][i*8+6] ;
				mem[address_r][i*8+7] = byte_enable_r[i] ? write_data_r[i*8+7] : mem[address_r][i*8+7] ;
			end              
		end
	end	
	
	task bfm_initialize();
		$display("bfm_initialize");
		set_parameters(DATA_WIDTH, ADDRESS_WIDTH);
	endtask
	
	// Auto-generated code to implement the BFM API
${cocotb_bfm_api_impl}
	
endmodule
