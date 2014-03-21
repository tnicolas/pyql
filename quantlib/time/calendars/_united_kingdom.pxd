cdef extern from 'ql/time/calendars/unitedkingdom.hpp' namespace 'QuantLib':
    
    cdef enum UKMarket 'QuantLib::UnitedKingdom::Market':
        UKSettlement 'QuantLib::UnitedKingdom::Market::Settlement'
        UKExchance 'QuantLib::UnitedKingdom::Market::Exchange'
        UKMetals 'QuantLib::UnitedKingdom::Market::Metals'
    
    cdef cppclass UnitedKingdom(Calendar):
        UnitedKingdom(UKMarket mkt)

