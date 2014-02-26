from quantlib.ql cimport shared_ptr, _rate_helpers as _rh

cdef class RateHelper:
    cdef shared_ptr[_rh.RateHelper]* _thisptr

cdef class RelativeDateRateHelper:
    cdef shared_ptr[_rh.RelativeDateRateHelper]* _thisptr
    
