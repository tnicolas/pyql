cdef extern from 'ql/time/daycounters/thirty360.hpp' namespace 'QuantLib':

    cdef enum Thirty360Convention 'QuantLib::Thirty360::Convention':
        Thirty360USA 'QuantLib::Thirty360::Convention::USA'
        Thirty360BondBasis 'QuantLib::Thirty360::Convention::BondBasis'
        Thirty360European 'QuantLib::Thirty360::Convention::European'
        Thirty360EurobondBasis 'QuantLib::Thirty360::Convention::EurobondBasis'
        Thirty360Italian 'QuantLib::Thirty360::Convention::Italian'

    cdef cppclass Thirty360(DayCounter):
        Thirty360(Thirty360Convention c)
