"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
cdef extern from "string" namespace "std":
    cdef cppclass string:
        char* c_str()

cdef extern from 'ql/indexes/swapindex.hpp' namespace 'QuantLib':

    cdef cppclass SwapIndex(InterestRateIndex):
        SwapIndex(string& familyName,
                  Period& tenor,
                  Natural settlementDays,
                  Currency currency,
                  Calendar& calendar,
                  Period& fixedLegTenor,
                  BusinessDayConvention fixedLegConvention,
                  DayCounter& fixedLegDayCounter,
                  shared_ptr[IborIndex]& iborIndex)
