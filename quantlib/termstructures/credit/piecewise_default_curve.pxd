from quantlib.ql cimport shared_ptr, _default_term_structure


cdef class PiecewiseDefaultCurve:

    cdef shared_ptr[_default_term_structure.DefaultProbabilityTermStructure]* _thisptr

