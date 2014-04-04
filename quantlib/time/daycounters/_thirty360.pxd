cdef extern from 'ql/time/daycounters/thirty360.hpp' namespace 'QuantLib':

    # renamed to prvent clashing with other Convention enums
    cdef enum Thirty360Convention 'QuantLib::Thirty360::Convention':
        pass

    cdef cppclass Thirty360(DayCounter):
        Thirty360(Thirty360Convention c)
