"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from libcpp cimport bool

from quantlib.ql cimport shared_ptr
from quantlib cimport ql

cimport date

cdef class Period:
    cdef shared_ptr[ql.Period]* _thisptr

cdef class Date:
    cdef shared_ptr[ql.Date]* _thisptr

cdef date.Date date_from_qldate(ql.Date& date)
