'''
Created on Feb 1, 2020

@author: ballance
'''

import cocotb
import pybfms

@pybfms.bfm(hdl={
    pybfms.BfmType.Verilog       : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_target_bfm.sv"),
    pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_target_bfm.sv")
    }, has_init=True)
class GenericSramByteEnTargetBFM(object):

    def __init__(self):
        self.dat_width = 0
        self.adr_width = 0
        self.endian = 0
        
    @pybfms.export_task(pybfms.uint64_t)
    def _read_req(self, adr):
        # TODO: get data value
        dat = 0
        
        # Send back to the BFM
        self._read_rsp(dat)
        pass
    
    @pybfms.import_task(pybfms.uint64_t)
    def _read_rsp(self, dat):
        pass
    
    @pybfms.export_task(pybfms.uint64_t,pybfms.uint64_t,pybfms.uint8_t)
    def _write_req(self, adr, dat, sel):
        # TODO: update data in the model
        pass
        
    @pybfms.export_task(pybfms.uint32_t, pybfms.uint32_t)
    def _set_parameters(self, dat_width, adr_width):
        """Called to set parameter values at initialization"""
        self.dat_width = dat_width
        self.adr_width = adr_width
        
    
        
    