from quantlib cimport ql
from quantlib.ql cimport shared_ptr

cdef class Quote:
    cdef shared_ptr[ql.Quote]* _thisptr

cdef class SimpleQuote(Quote):
    pass
