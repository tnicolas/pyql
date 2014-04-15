from quantlib cimport ql
from quantlib.time.calendar cimport Calendar

cdef class Switzerland(Calendar):
    ''' Swiss calendars.
   '''

    def __cinit__(self):

        self._thisptr = <ql.Calendar*> new \
            ql.Switzerland()
