from quantlib.ql cimport _black_vol_term_structure as _bv, shared_ptr

cdef class BlackVolTermStructure:
    cdef shared_ptr[_bv.BlackVolTermStructure]* _thisptr

