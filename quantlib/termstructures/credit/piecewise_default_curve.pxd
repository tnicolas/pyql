from quantlib cimport ql

cdef class PiecewiseDefaultCurve:

    cdef ql.shared_ptr[ql.DefaultProbabilityTermStructure]* _thisptr

