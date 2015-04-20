"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
from cython.operator cimport dereference as deref

from quantlib.handle cimport Handle, shared_ptr
cimport _pricing_engine as _pe
cimport _bond

from engine cimport PricingEngine

cimport quantlib.termstructures._yield_term_structure as _yts
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class DiscountingBondEngine(PricingEngine):

    def __init__(self, YieldTermStructure discount_curve):
        """
        """
        cdef Handle[_yts.YieldTermStructure] yts_handle = \
            deref(discount_curve._thisptr.get())

        self._thisptr = new shared_ptr[_pe.PricingEngine](
            new _bond.DiscountingBondEngine(yts_handle)
        )
