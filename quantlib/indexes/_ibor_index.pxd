"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/indexes/iborindex.hpp' namespace 'QuantLib':

    # base class for Inter-Bank-Offered-Rate indexes (e.g. %Libor, etc.)
    cdef cppclass IborIndex(InterestRateIndex):
        IborIndex()
        # constructor with default YieldTermStructure
        IborIndex(string& familyName,
                  Period& tenor,
                  Natural settlementDays,
                  Currency& currency,
                  Calendar& fixingCalendar,
                  BusinessDayConvention convention,
                  bool endOfMonth,
                  DayCounter& dayCounter) except +
        IborIndex(string& familyName,
                  Period& tenor,
                  Natural settlementDays,
                  Currency& currency,
                  Calendar& fixingCalendar,
                  BusinessDayConvention convention,
                  bool endOfMonth,
                  DayCounter& dayCounter,
                  Handle[YieldTermStructure]& h) except +

        # \name Inspectors
        BusinessDayConvention businessDayConvention() except +
        bool endOfMonth() except +

        # the curve used to forecast fixings
        Handle[YieldTermStructure] forwardingTermStructure()

        # \name Date calculations
        Date maturityDate(Date& valueDate)

        # returns a copy of itself linked to a different forwarding curve
        shared_ptr[IborIndex] clone(Handle[YieldTermStructure]& forwarding)

    cdef cppclass OvernightIndex(IborIndex):
        OvernightIndex()
        OvernightIndex(string& familyName,
                       Natural settlementDays,
                       Currency& currency,
                       Calendar& fixingCalendar,
                       DayCounter& dayCounter,
                       Handle[YieldTermStructure]& h)
        # returns a copy of itself linked to a different forwarding curve
        shared_ptr[IborIndex] clone(Handle[YieldTermStructure]& h)
