from quantlib cimport ql

cdef class DayCounter:

    cdef ql.DayCounter* _thisptr
