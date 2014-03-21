"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib cimport ql

cdef class Currency:
    cdef ql.Currency *_thisptr

cdef class USDCurrency(Currency):
    pass

cdef class EURCurrency(Currency):
    pass
