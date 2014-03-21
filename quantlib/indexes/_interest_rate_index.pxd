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

cdef extern from 'ql/indexes/interestrateindex.hpp' namespace 'QuantLib':

    cdef cppclass InterestRateIndex(Index):
        InterestRateIndex()
        #FIXME: why is this commented?
#        InterestRateIndex(string& familyName,
#                          Period& tenor,
#                          Natural settlementDays,
#                          Currency& currency,
#                          Calendar& fixingCalendar,
#                          DayCounter& dayCounter)
        string name()
        Calendar fixingCalendar( )
        bool isValidFixingDate(Date& fixingDate)
        Rate fixing(Date& fixingDate,
                    bool forecastTodaysFixing)
        update()
        string familyName()
        Period tenor()
        Natural fixingDays()
        Date fixingDate(Date& valueDate)
        Currency& currency()
        DayCounter& dayCounter()

        Date valueDate(Date& fixingDate)
        Date maturityDate(Date& valueDate)
