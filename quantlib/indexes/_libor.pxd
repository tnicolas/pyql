"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/indexes/ibor/libor.hpp' namespace 'QuantLib':

    cdef cppclass Libor(IborIndex):
        Libor()
        Libor(string& familyName,
                  Period& tenor,
                  Natural settlementDays,
                  Currency& currency,
                  Calendar& finencialCenterCalendar,
                  DayCounter& dayCounter,
                  Handle[YieldTermStructure]& h) except +

