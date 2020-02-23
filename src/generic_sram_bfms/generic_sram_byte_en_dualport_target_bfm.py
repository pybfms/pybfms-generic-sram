'''
Created on Feb 1, 2020

@author: ballance
'''

import cocotb
from cocotb.decorators import bfm_uint32_t, bfm_uint64_t
from cocotb.triggers import Lock, Event

@cocotb.bfm(hdl={
    cocotb.bfm_sv : cocotb.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_dualport_target_bfm.sv"),
    cocotb.bfm_vlog : cocotb.bfm_hdl_path(__file__, "hdl/generic_sram_byte_en_dualport_target_bfm.sv")
    }, has_init=True)
class GenericSramByteEnDualportTargetBFM():

    def __init__(self):
        self.data_width = 0
        self.addr_width = 0
        self.endian = 0
        self.lock = Lock()
        self.ack_ev = Event()
        
    @cocotb.bfm_export(bfm_uint32_t, bfm_uint32_t)
    def set_parameters(self, data_width, addr_width):
        """Called to set parameter values at initialization"""
        self.data_width = data_width
        self.addr_width = addr_width
        
    @cocotb.coroutinee
    def read(self, addr):
        yield self.lock.acquire()
        yield self._read_req(addr)
        
        ret = yield self.ack_ev.wait()
        
        self.lock.release()
        
        return ret
    
    @cocotb.coroutine
    def write(self, addr, data, byte_en):
        yield self.lock.acquire()
        yield self._write_req(addr, data, byte_en)
        
        yield self.ack_ev.wait()
        
        self.lock.release()


    @cocotb.bfm_import(bfm_uint32_t)
    def _read_req(self, addr):
        pass
    
    @cocotb.bfm_export(bfm_uint64_t)
    def _read_ack(self, data):
        self.ack_ev.set(data)
        

    @cocotb.bfm_import(bfm_uint32_t,bfm_uint64_t,bfm_uint32_t)
    
    
        
    