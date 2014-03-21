from quantlib cimport ql

cdef class GeneralizedBlackScholesProcess:

    cdef ql.shared_ptr[ql.GeneralizedBlackScholesProcess]* _thisptr



