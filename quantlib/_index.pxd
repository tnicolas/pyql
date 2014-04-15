"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

cdef extern from 'ql/index.hpp' namespace 'QuantLib':

    cdef cppclass Index:
        Index()
        string name()
        Calendar& fixingCalendar()
        bool isValidFixingDate(Date& fixingDate)
        Real fixing(Date& fixingDate, bool forecastTodaysFixing)
        void addFixing(Date& fixingDate, Real fixing, bool forceOverwrite)

