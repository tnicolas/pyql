cdef extern from 'ql/termstructures/yield/zerocurve.hpp' namespace 'QuantLib':

    cdef cppclass ZeroCurve(YieldTermStructure):

        ZeroCurve(
            vector[Date]& dates,
            vector[Rate]& yields,
            DayCounter& dayCounter
        ) except +
