'''
Created on Feb 1, 2020

@author: ballance
'''

import pybfms

@pybfms.bfm(hdl={
    pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_dualport_target_bfm.sv"),
    pybfms.BfmType.Verilog : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_dualport_target_bfm.sv")
    }, has_init=True)
class GenericSramByteEnDualportTargetBFM():

    def __init__(self):
        self.data_width = 0
        self.addr_width = 0
        self.endian = 0
        self.lock = pybfms.lock()
        self.ack_ev = pybfms.event()
        self.read_data = None
        self.mem = []
        
    @pybfms.export_task(pybfms.uint32_t, pybfms.uint32_t)
    def _set_parameters(self, data_width, addr_width):
        """Called to set parameter values at initialization"""
        self.data_width = data_width
        self.addr_width = addr_width
        self.mem = [0]*(1 << addr_width)
        
    async def read(self, addr):
        await self.lock.acquire()
        self._read_req(addr)
        
        await self.ack_ev.wait()
        self.ack_ev.clear()
        ret = self.read_data
        
        self.lock.release()
        
        return ret
    
    async def write(self, addr, data, byte_en):
        await self.lock.acquire()
        self._write_req(addr, data, byte_en)
        
        await self.ack_ev.wait()
        
        self.lock.release()
        
    def write_nb(self, addr, data, byte_en):
        # TODO:
        self.mem[addr] = data

    @pybfms.export_task(pybfms.uint32_t)
    def _read_req_a(self, addr):
        # TODO:
        addr = addr % len(self.mem)
        self._read_rsp_a(self.mem[addr])
        
    @pybfms.import_task(pybfms.uint64_t)
    def _read_rsp_a(self, data):
        pass
    
    @pybfms.export_task(pybfms.uint32_t, pybfms.uint64_t, pybfms.uint16_t)
    def _write_req_a(self, addr, data, sel):
        addr = addr % len(self.mem)
        ex_data = self.mem[addr]
        # TODO:
        self.mem[addr] = ex_data
        pass
    
    @pybfms.export_task(pybfms.uint32_t)
    def _read_req_b(self, addr):
        # TODO:
        addr = addr % len(self.mem)
        self._read_rsp_b(self.mem[addr])
        
    @pybfms.import_task(pybfms.uint64_t)
    def _read_rsp_b(self, data):
        pass
    
    @pybfms.export_task(pybfms.uint32_t, pybfms.uint64_t, pybfms.uint16_t)
    def _write_req_b(self, addr, data, sel):
        addr = addr % len(self.mem)
        ex_data = self.mem[addr]
        # TODO:
        self.mem[addr] = ex_data
        pass
    
        
