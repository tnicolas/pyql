from quantlib cimport ql

cdef class BlackVolTermStructure:
    cdef ql.shared_ptr[ql.BlackVolTermStructure]* _thisptr

