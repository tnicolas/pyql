from quantlib.ql cimport _quote as _qt, shared_ptr


cdef class Quote:
    cdef shared_ptr[_qt.Quote]* _thisptr

cdef class SimpleQuote(Quote):
    pass
