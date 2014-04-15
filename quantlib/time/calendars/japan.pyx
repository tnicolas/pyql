from quantlib cimport ql

from quantlib.time.calendar cimport Calendar

cdef class Japan(Calendar):
    ''' Japan calendars.
   '''

    def __cinit__(self):

        self._thisptr = <ql.Calendar*> new ql.Japan()
