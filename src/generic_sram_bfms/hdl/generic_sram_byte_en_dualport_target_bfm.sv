/****************************************************************************
 * generic_sram_byte_en_dualport_target_bfm
 * 
 * Implements a target BFM for a dual-port SRAM with byte enabled writes.
 ****************************************************************************/

module generic_sram_byte_en_dualport_target_bfm #(
		parameter DAT_WIDTH			= 32,
		parameter ADR_WIDTH			= 8
		) (
		input						clock,
		input [ADR_WIDTH-1:0]		a_adr,
		output[DAT_WIDTH-1:0]		a_dat_r,
		input[DAT_WIDTH/8-1:0]		a_sel,
		input						a_we,
		input[DAT_WIDTH-1:0]		a_dat_w,
		
		input [ADR_WIDTH-1:0]		b_adr,
		output[DAT_WIDTH-1:0]		b_dat_r,
		input[DAT_WIDTH/8-1:0]		b_sel,
		input						b_we,
		input[DAT_WIDTH-1:0]		b_dat_w
		);

	reg[ADR_WIDTH-1:0]		a_adr_last = 0;
	reg[3:0]				a_adr_last_valid = 4'h0;
	reg[DAT_WIDTH-1:0]		a_dat_r_v = {DAT_WIDTH{1'b0}};
	
	assign a_dat_r = a_dat_r_v;

	always @(posedge clock) begin
		if (a_we) begin
			_write_req_a(a_adr, a_dat_w, a_sel);
		end else begin
			if ((a_adr_last !== a_adr) || (a_adr_last_valid != 'hf)) begin
				a_adr_last <= a_adr;
				a_adr_last_valid <= a_adr_last_valid + 1;
				_read_req_a(a_adr);
			end
		end
	end
	
	reg[ADR_WIDTH-1:0]		b_adr_last = 0;
	reg						b_adr_last_valid = 0;
	reg[DAT_WIDTH-1:0]		b_dat_r_v = {DAT_WIDTH{1'b0}};
	
	assign b_dat_r = b_dat_r_v;

	always @(posedge clock) begin
		if (b_we) begin
			_write_req_b(b_adr, b_dat_w, b_sel);
		end else begin
			if ((b_adr_last !== b_adr) || !b_adr_last_valid) begin
				b_adr_last <= b_adr;
				b_adr_last_valid <= 1'b1;
				_read_req_b(b_adr);
			end
		end
	end
	
	/**
	 * Task: init
	 * 
	 * Task description needed
	 * 
	 * Parameters:
	 */
	task init;
	begin
		$display("%m: generic_sram_byte_en_dualport_target_bfm");
		_set_parameters(DAT_WIDTH, ADR_WIDTH);
	end
	endtask

	/**
	 * Task: _read_rsp_a
	 * 
	 * Parameters:
	 * - bit addr 
	 */
	task _read_rsp_a(input reg[63:0] data);
	begin
		a_dat_r_v = data;
	end
	endtask

	/**
	 * Task: _read_rsp_b
	 * 
	 */
	task _read_rsp_b(input reg[63:0] data);
	begin
		b_dat_r_v = data;
	end
	endtask
	
	// Auto-generated code to implement the BFM API
`ifdef PYBFMS_GEN
${pybfms_api_impl}
`endif		
endmodule
