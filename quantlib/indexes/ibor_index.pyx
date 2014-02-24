include '../types.pxi'
from cython.operator cimport dereference as deref

from quantlib.time.date cimport Period
from quantlib.time.daycounter cimport DayCounter
from quantlib.currency cimport Currency
from quantlib.time.calendar cimport Calendar
from quantlib.indexes.interest_rate_index cimport InterestRateIndex

cdef extern from "string" namespace "std":
    cdef cppclass string:
        char* c_str()

cdef class IborIndex(InterestRateIndex):
    def __cinit__(self):
        pass

cdef class OvernightIndex(IborIndex):
    def __cinit__(self):
        pass

