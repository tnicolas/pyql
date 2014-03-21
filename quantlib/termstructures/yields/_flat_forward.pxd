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

cdef extern from 'ql/termstructures/yield/flatforward.hpp' namespace 'QuantLib':

    cdef cppclass FlatForward(YieldTermStructure):

        FlatForward(DayCounter& dc,
                   vector[Handle[Quote]]& jumps,
                   vector[Date]& jumpDates,
        ) except +


        FlatForward(Date& referenceDate,
                   Rate forward,
                   DayCounter& dayCounter,
                   Compounding compounding,
                   Frequency frequency
        ) except +

        FlatForward(Natural settlementDays,
                    Calendar& calendar,
                    Rate forward,
                    DayCounter& dayCounter,
                    Compounding compounding,
                    Frequency frequency
        ) except +

        # from days and quote :
        FlatForward(Natural settlementDays,
                    Calendar& calendar,
                    Handle[Quote]& forward,
                    DayCounter& dayCounter,
        ) except +
        
        FlatForward(Natural settlementDays,
                    Calendar& calendar,
                    Handle[Quote]& forward,
                    DayCounter& dayCounter,
                    Compounding compounding,
        ) except +
        
        FlatForward(Natural settlementDays,
                    Calendar& calendar,
                    Handle[Quote]& forward,
                    DayCounter& dayCounter,
                    Compounding compounding,
                    Frequency frequency
        ) except +
        
        # from date and forward
        FlatForward(Date& referenceDate,
                    Handle[Quote]& forward,
                    DayCounter& dayCounter,
                    Compounding compounding,
                    Frequency frequency
        ) except +
