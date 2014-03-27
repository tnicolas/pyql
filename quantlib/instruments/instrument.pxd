from libcpp cimport bool as cbool

from quantlib cimport ql

cdef class Instrument:

    cdef cbool _has_pricing_engine
    cdef ql.shared_ptr[ql.Instrument]* _thisptr
