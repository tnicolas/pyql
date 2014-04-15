"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/compounding.hpp' namespace 'QuantLib':
    cdef enum Compounding:
        Simple = 0
        Compounded = 1
        Continuous = 2
        SimpleThenCompounded = 3

cdef extern from 'ql/termstructures/yieldtermstructure.hpp' namespace 'QuantLib':

    cdef cppclass YieldTermStructure:

        YieldTermStructure() except +
        YieldTermStructure(DayCounter& dc,
                           vector[Handle[Quote]]& jumps,
                           vector[Date]& jumpDates,
                           ) except +
        DiscountFactor discount(Date& d) except +
        DiscountFactor discount(Date& d, bool extrapolate) except +
        DiscountFactor discount(Time t) except +
        DiscountFactor discount(Time t, bool extrapolate) except +
        Date& referenceDate()
        Date& maxDate()
        InterestRate zeroRate(Date& d,
                              DayCounter& resultDayCounter,
                              Compounding comp,
                              Frequency freq,  # = Annual
                              bool extrapolate  # = False
                              ) except +
        InterestRate forwardRate(Date& d1,
                                 Date& d2,
                                 DayCounter& resultDayCounter,
                                 Compounding comp,
                                 Frequency freq,  # = Annual
                                 bool extrapolate  # = False
                             ) except +
