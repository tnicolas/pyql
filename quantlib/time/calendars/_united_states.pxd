cdef extern from 'ql/time/calendars/unitedstates.hpp' namespace 'QuantLib':

    # redefined to prevent clashing with other calendar conventions    
    cdef enum USMarket "QuantLib::UnitedStates::Market":
        pass

    cdef cppclass UnitedStates(Calendar):
        UnitedStates(USMarket mkt)

