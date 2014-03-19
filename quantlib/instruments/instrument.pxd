from libcpp cimport bool as cbool

from quantlib.ql cimport shared_ptr
from quantlib cimport ql

cdef class Instrument:

    cdef cbool _has_pricing_engine
    cdef shared_ptr[ql.Instrument]* _thisptr
