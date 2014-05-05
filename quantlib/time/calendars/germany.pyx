from quantlib cimport ql
from quantlib.time.calendar cimport Calendar

SETTLEMENT = 0
FRANKFURT_STOCK_EXCHANGE = 1
XETRA = 2
EUREX = 3
EUWAX = 4

cdef class Germany(Calendar):
    ''' Germany calendars.
   '''

    def __cinit__(self, market=SETTLEMENT):

        self._thisptr = <ql.Calendar*> new \
            ql.Germany(market)


