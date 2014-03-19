from cython.operator cimport dereference as deref
from quantlib cimport ql # _calendar as _cal, _jointcalendar as _jc

from quantlib.time.calendar cimport Calendar

cdef enum JointCalendarRule:
    JOINHOLIDAYS = ql.JoinHolidays
    JOINBUSINESSDAYS = ql.JoinBusinessDays

cdef class JointCalendar(Calendar):
    '''
    Joint calendar
    Depending on the chosen rule, this calendar has a set of
    business days given by either the union or the intersection
    of the sets of business days of the given calendars.
    '''
    
    def __cinit__(self, Calendar c1, Calendar c2, int jc = JOINHOLIDAYS):
        self._thisptr = new ql.JointCalendar(deref(c1._thisptr),
                                  deref(c2._thisptr),
                                  <ql.JointCalendarRule> jc)

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

