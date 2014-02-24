from quantlib.ql cimport _flat_forward as _ff,  shared_ptr, RelinkableHandle
from libcpp cimport bool as cbool

cdef class YieldTermStructure:
    cdef shared_ptr[_ff.YieldTermStructure]* _thisptr
    cdef shared_ptr[RelinkableHandle[_ff.YieldTermStructure]]* _relinkable_ptr
    cdef cbool relinkable
