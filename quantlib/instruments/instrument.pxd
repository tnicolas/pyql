from libcpp cimport bool as cbool

from quantlib.ql cimport shared_ptr, _instrument

cdef class Instrument:

    cdef cbool _has_pricing_engine
    cdef shared_ptr[_instrument.Instrument]* _thisptr
