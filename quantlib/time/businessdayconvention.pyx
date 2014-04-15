"""
 Copyright (C) 2014, Enthought Inc
 Copyright (C) 2014, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from libcpp.string cimport string
from quantlib cimport ql

# BusinessDayConvention:
cdef QL_BDC = [ql.Following, ql.ModifiedFollowing,
               ql.Preceding, ql.ModifiedPreceding,
               ql.Unadjusted]

_BDC_DICT = {str(BusinessDayConvention(v)).replace(" ",""):v for v in QL_BDC}

cdef class BusinessDayConvention(int):
    def __cinit__(self):
        pass

    @classmethod
    def from_name(cls, name):
        return BusinessDayConvention(_BDC_DICT[name])

    @classmethod
    def help(cls):
        res = 'Valid business day conventions:\n'
        for s in _BDC_DICT:
            res += s + '\n'
        return res

    def __str__(self):
        cdef string res = ql.repr(int(self))
        return res.c_str()

    def __repr__(self):
        cdef string res = ql.repr(int(self))
        return('Business Day Convention: %s' % res.c_str())

