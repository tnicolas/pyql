
from quantlib cimport ql
from quantlib.ql cimport shared_ptr


cdef class DefaultProbabilityTermStructure: #not inheriting from TermStructure at this point

    cdef shared_ptr[ql.DefaultProbabilityTermStructure]* _thisptr
