cdef extern from 'ql/time/calendars/unitedkingdom.hpp' namespace 'QuantLib':

    # renamed to avoid clashes with other Market enums
    cdef enum UKMarket 'QuantLib::UnitedKingdom::Market':
        pass

    cdef cppclass UnitedKingdom(Calendar):
        UnitedKingdom(UKMarket mkt)

