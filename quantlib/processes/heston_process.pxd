from quantlib cimport ql

cdef class HestonProcess:

    cdef ql.shared_ptr[ql.HestonProcess]* _thisptr
