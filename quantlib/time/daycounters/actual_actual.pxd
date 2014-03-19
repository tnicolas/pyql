from quantlib cimport ql
from quantlib.time.daycounter cimport DayCounter


cdef class ActualActual(DayCounter):
    pass


cdef ql.DayCounter* from_name(str name, str convention)

