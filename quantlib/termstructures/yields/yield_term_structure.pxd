from quantlib.ql cimport shared_ptr
from quantlib cimport ql
from libcpp cimport bool as cbool

cdef class YieldTermStructure:
    cdef shared_ptr[ql.YieldTermStructure]* _thisptr
    cdef shared_ptr[ql.RelinkableHandle[ql.YieldTermStructure]]* _relinkable_ptr
    cdef cbool relinkable
