from quantlib.ql cimport _daycounter

cdef class DayCounter:

    cdef _daycounter.DayCounter* _thisptr
