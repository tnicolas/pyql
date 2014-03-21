from quantlib cimport ql

cdef class RateHelper:
    cdef ql.shared_ptr[ql.RateHelper]* _thisptr

cdef class RelativeDateRateHelper:
    cdef ql.shared_ptr[ql.RelativeDateRateHelper]* _thisptr
    
