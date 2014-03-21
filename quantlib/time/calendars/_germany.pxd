cdef extern from 'ql/time/calendars/germany.hpp' namespace 'QuantLib':

    cdef enum GermanMarket 'QuantLib::Germany::Market':
        DESettlement  'QuantLib::Germany::Market::Settlement'
        FrankfurtStockExchange 'QuantLib::Germany::Market::FrankfurtStockExchange'
        Xetra 'QuantLib::Germany::Market::Xetra'
        Eurex 'QuantLib::Germany::Market::Eurex'
        Euwax  'QuantLib::Germany::Market::Euwax'
    
    cdef cppclass Germany(Calendar):
        Germany(GermanMarket mkt)

