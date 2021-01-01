/****************************************************************************
 * generic_sram_byte_en_target_bfm.sv
 * 
 ****************************************************************************/

module generic_sram_byte_en_target_bfm #(
		parameter DAT_WIDTH		= 32,
		parameter ADR_WIDTH		= 8
		) (
		input						clock,
		output[DAT_WIDTH-1:0]		dat_w,
		input [ADR_WIDTH-1:0]		adr,
		input [DAT_WIDTH/8-1:0]		sel,
		output[DAT_WIDTH-1:0]		dat_r
		);

	reg[ADR_WIDTH-1:0]			last_adr = 0;
	reg							last_adr_valid = 0;
	reg[DAT_WIDTH-1:0]			dat_r_r = 0;
	
	assign dat_r = dat_r_r;
	
	always @(posedge clock) begin
		if (adr != last_adr || !last_adr_valid) begin
			_read_req(adr);
			last_adr <= adr;
			last_adr_valid <= 1'b1;
		end
		
		if (|sel) begin
			_write_req(adr, dat_w, sel);
		end
	end
	
	task _read_rsp(input reg[63:0] dat);
	begin
		dat_r_r = dat;
	end
	endtask
	
	task init;
	begin
		$display("%m: generic_sram_byte_en_target_bfm");
		_set_parameters(DAT_WIDTH, ADR_WIDTH);
	end
	endtask
	
	// Auto-generated code to implement the BFM API
`ifdef PYBFMS_GEN
${pybfms_api_impl}
`endif	
endmodule
