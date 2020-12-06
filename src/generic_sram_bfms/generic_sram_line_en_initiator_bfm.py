'''
Created on Oct 8, 2019

@author: ballance
'''

import pybfms
import os


@pybfms.bfm(hdl={
    pybfms.BfmType.Verilog : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_line_en_initiator_bfm.v"),
    pybfms.BfmType.SystemVerilog : pybfms.bfm_hdl_path(__file__, "hdl/generic_sram_line_en_initiator_bfm.v")
    }, has_init=True)
class GenericSramLineEnInitiatorBFM(object):
    
    def __init__(self):
        self.ADR_WIDTH = 0
        self.DAT_WIDTH = 0
        self.RD_CYCLES = 0
        self.RW_CYCLES = 0
        self.busy = pybfms.lock()
        self.ack_ev = pybfms.event()
        self.reset_ev = pybfms.event()
        self.is_reset = False
        self.read_data = 0;
        
    async def write(self, addr, data):
        await self.busy.acquire()
        
        if not self.is_reset:
            await self.reset_ev
            self.reset_ev.clear()
            
        await self._rw_req(addr, data, 1)
        
        await self.ack_ev
        self.ack_ev.clear()
        
        self.busy.release()
        
    async def read(self, addr):
        await self.busy.acquire()
        
        if not self.is_reset:
            await self.reset_ev
            self.reset_ev.clear()
            
        await self._rw_req(addr, 0, 0)
        
        await self.ack_ev
        self.ack_ev.clear()
        
        self.busy.release()
        
        return self.read_data
    
    @pybfms.import_task(pybfms.uint64_t,pybfms.uint64_t,pybfms.uint8_t)
    def _rw_req(self, addr, write_data, we):
        pass
    
    @pybfms.export_task(pybfms.uint64_t)
    def _rw_ack(self, read_data):
        self.read_data = read_data
        self.ack_ev.set()
    
    @pybfms.export_task(pybfms.uint32_t,pybfms.uint32_t,pybfms.uint32_t,pybfms.uint32_t)
    def _set_parameters(self, ADR_WIDTH, DAT_WIDTH, RD_CYCLES, WR_CYCLES):
        self.ADR_WIDTH = ADR_WIDTH
        self.DAT_WIDTH = DAT_WIDTH
        self.RD_CYCLES = RD_CYCLES
        self.RW_CYCLES = WR_CYCLES
    
    @pybfms.export_task()
    def _reset(self):
        self.is_reset = True
        self.reset_ev.set()
        