from quantlib cimport ql
from quantlib.time.daycounter cimport DayCounter


cdef class Thirty360(DayCounter):
    pass


cdef ql.DayCounter* from_name(str name, str convention)
