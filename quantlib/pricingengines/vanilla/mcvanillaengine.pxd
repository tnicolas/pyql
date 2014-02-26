from quantlib.ql cimport _pricing_engine as _pe, shared_ptr
from quantlib.pricingengines.engine cimport PricingEngine

cdef class MCVanillaEngine(PricingEngine):
    pass

