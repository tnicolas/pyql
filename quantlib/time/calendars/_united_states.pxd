cdef extern from 'ql/time/calendars/unitedstates.hpp' namespace 'QuantLib':

    # redefined to prevent clashing with other calendar conventions    
    cdef enum USMarket "QuantLib::UnitedStates::Market":
        USSettlement "QuantLib::UnitedStates::Market::Settlement" 
        USNYSE "QuantLib::UnitedStates::Market::NYSE"
        USGovernmentBond "QuantLib::UnitedStates::Market::GovernmentBond"
        USNERC "QuantLib::UnitedStates::Market::NERC"
    
    cdef cppclass UnitedStates(Calendar):
        UnitedStates(USMarket mkt)

