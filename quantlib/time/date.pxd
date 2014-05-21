"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib cimport ql

cdef class Period:
    cdef ql.shared_ptr[ql.Period]* _thisptr

cdef class Date:
    cdef ql.shared_ptr[ql.Date]* _thisptr

cdef inline Date date_from_qldate(ql.Date& date):
    '''Converts a QuantLib::Date (ql.Date) to a cython Date instance.

    Inefficient because taking a copy of the date ... but safe!
    '''
    return Date(date.serialNumber())
