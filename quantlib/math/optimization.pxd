from quantlib cimport ql

cdef class OptimizationMethod:

    cdef ql.shared_ptr[ql.OptimizationMethod]* _thisptr

cdef class EndCriteria:

    cdef ql.shared_ptr[ql.EndCriteria]* _thisptr


