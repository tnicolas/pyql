from quantlib cimport ql
from quantlib.time.calendar cimport Calendar

SETTLEMENT = ql.DESettlement
FrankfurtStockExchange = ql.FrankfurtStockExchange
XETRA = ql.Xetra
EUREX = ql.Eurex
EUWAX = ql.Euwax

cdef class Germany(Calendar):
    ''' Germany calendars.
   '''

    def __cinit__(self, market=SETTLEMENT):

        self._thisptr = <ql.Calendar*> new \
            ql.Germany(<ql.GermanMarket>market)


