cdef extern from 'ql/time/calendars/germany.hpp' namespace 'QuantLib':

    # renamed to avoid clashing with other Market enums
    cdef enum GermanMarket 'QuantLib::Germany::Market':
        Settlement
        FrankfurtStockExchange
        Xetra
        Eurex
        Euwax

    cdef cppclass Germany(Calendar):
        Germany(GermanMarket mkt)

