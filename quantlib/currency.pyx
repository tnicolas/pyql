"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from quantlib cimport ql
from quantlib.utils.prettyprint import prettyprint

cdef class Currency:
    def __cinit__(self):
        self._thisptr = new ql.Currency()

    property name:
        def __get__(self):
            return self._thisptr.name().c_str()

    property code:
        def __get__(self):
            return self._thisptr.code().c_str()

    property symbol:
        def __get__(self):
            return self._thisptr.symbol().c_str()

    property fractionSymbol:
        def __get__(self):
            return self._thisptr.fractionSymbol().c_str()

    property fractionsPerUnit:
        def __get__(self):
            return self._thisptr.fractionsPerUnit()

    def __str__(self):
        if not self._thisptr.empty():
            return self._thisptr.name().c_str()
        else:
            return 'null currency'

    _lookup = dict([(cu.code, (cu.name, cu)) for cu in
                [USDCurrency(), EURCurrency(), GBPCurrency(),
                 JPYCurrency(), CHFCurrency(), AUDCurrency(),
                 DKKCurrency(), INRCurrency(), HKDCurrency(),
                 NOKCurrency(), NZDCurrency(), PLNCurrency(),
                 SEKCurrency(), SGDCurrency(), ZARCurrency()]])

    @classmethod
    def help(cls):
        tmp = [(k, v[0]) for k, v in cls._lookup.items()]
        tmp = map(list, zip(*tmp))
        return prettyprint(('Code', 'Currency'), 'ss', tmp)

    @classmethod
    def from_name(cls, code):
        return cls._lookup[code][1]

cdef class USDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.USDCurrency()

cdef class EURCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.EURCurrency()

cdef class GBPCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.GBPCurrency()

cdef class JPYCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.JPYCurrency()

cdef class CHFCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.CHFCurrency()

cdef class AUDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.AUDCurrency()

cdef class DKKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.DKKCurrency()

cdef class INRCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.INRCurrency()

cdef class HKDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.HKDCurrency()

cdef class NOKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.NOKCurrency()

cdef class NZDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.NZDCurrency()

cdef class PLNCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.PLNCurrency()

cdef class SEKCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.SEKCurrency()

cdef class SGDCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.SGDCurrency()

cdef class ZARCurrency(Currency):
    def __cinit__(self):
        self._thisptr = <ql.Currency*> new ql.ZARCurrency()
