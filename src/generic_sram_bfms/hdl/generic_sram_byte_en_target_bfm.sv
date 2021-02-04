/****************************************************************************
 * generic_sram_byte_en_target_bfm.sv
 * 
 ****************************************************************************/

module generic_sram_byte_en_target_bfm #(
		parameter DAT_WIDTH		= 32,
		parameter ADR_WIDTH		= 8
		) (
		input						clock,
		input [ADR_WIDTH-1:0]		adr,
		input						we,
		input [DAT_WIDTH/8-1:0]		sel,
		output reg[DAT_WIDTH-1:0]	dat_r,
		input[DAT_WIDTH-1:0]		dat_w
		);

	reg[ADR_WIDTH-1:0]		adr_last = 0;
	reg[3:0]				adr_last_valid = 4'h0;
	reg[DAT_WIDTH-1:0]		dat_r_v = {DAT_WIDTH{1'b0}};

//	always @* dat_r = dat_r_v;

	always @(posedge clock) begin
		if (we) begin
			if (adr === adr_last) begin
				adr_last_valid <= 0;
			end
		end else begin
			if (adr_last === adr) begin
				adr_last_valid <= adr_last_valid + 1;
			end else begin
				adr_last_valid <= 0;
			end
		end
	end
	
	always @(negedge clock) begin
		if (!we) begin
			if ((adr_last !== adr) || (adr_last_valid != 'h10)) begin
				adr_last <= adr;
				_read_req(adr);
			end
		end
		dat_r <= dat_r_v;
	end
	
	always @(posedge clock) begin
		if (we) begin
			_write_req(adr, dat_w, sel);
		end
	end
	
	task _read_rsp(input reg[63:0] dat);
	begin
		dat_r_v = dat;
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
