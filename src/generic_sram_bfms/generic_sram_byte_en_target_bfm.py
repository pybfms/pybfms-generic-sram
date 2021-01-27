'''
Created on Feb 1, 2020

@author: ballance
'''

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
        self.mem = []
        
    def write_nb(self, addr, data, byte_en):
        if addr >= len(self.mem):
            raise Exception("Address " + hex(addr) + " outside memory " + hex(len(self.mem)))
        self.mem[addr] = data
        
    def read_nb(self, addr):
        if addr >= len(self.mem):
            raise Exception("Address " + hex(addr) + " outside memory " + hex(len(self.mem)))
        return self.mem[addr]        
        
    @pybfms.export_task(pybfms.uint32_t)
    def _read_req(self, addr):
        if len(self.mem) > 0:
            addr = addr % len(self.mem)
            self._read_rsp(self.mem[addr])
        else:
            self._read_rsp(0)
        
        pass
    
    @pybfms.import_task(pybfms.uint64_t)
    def _read_rsp(self, dat):
        pass
    
    @pybfms.export_task(pybfms.uint64_t,pybfms.uint64_t,pybfms.uint8_t)
    def _write_req(self, addr, data, sel):
        if len(self.mem) > 0:
            addr = addr % len(self.mem)
            ex_data = self.mem[addr]
            wr_data = 0
            for i in range(int(self.dat_width/8)):
                if sel & (1 << i):
                    wr_data |= (data & (0xFF << 8*i))
                else:
                    wr_data |= (ex_data & (0xFF << 8*i))

            self.mem[addr] = wr_data        
        
    @pybfms.export_task(pybfms.uint32_t, pybfms.uint32_t)
    def _set_parameters(self, dat_width, adr_width):
        """Called to set parameter values at initialization"""
        self.dat_width = dat_width
        self.adr_width = adr_width
        self.mem = [0]*(1 << adr_width)
        
    
        
    