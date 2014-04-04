from quantlib cimport ql
from quantlib.time.calendar cimport Calendar

cdef extern from 'ql/time/calendars/germany.hpp' namespace 'QuantLib::Germany':

    cdef enum Market:
        Settlement
        FrankfurtStockExchange
        Xetra
        Eurex
        Euwax

SETTLEMENT = Settlement
FRANKFURT_STOCK_EXCHANGE = FrankfurtStockExchange
XETRA = Xetra
EUREX = Eurex
EUWAX = Euwax

cdef class Germany(Calendar):
    ''' Germany calendars.
   '''

    def __cinit__(self, market=SETTLEMENT):

        self._thisptr = <ql.Calendar*> new \
            ql.Germany(market)


