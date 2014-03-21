from quantlib cimport ql

cdef class InterestRate:
    cdef ql.shared_ptr[ql.InterestRate]* _thisptr

