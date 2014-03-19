from quantlib cimport ql

from libcpp.vector cimport vector

cdef class Calendar:
    cdef ql.Calendar* _thisptr

cdef class TARGET(Calendar):
    pass

cdef class UnitedStates(Calendar):
    pass

cdef class UnitedKingdom(Calendar):
    pass

cdef class DateList:
    cdef vector[ql.Date]* _dates
    cdef size_t _pos
    cdef _set_dates(self, vector[ql.Date]& dates)

