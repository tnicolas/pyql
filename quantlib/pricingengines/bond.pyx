"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref

from quantlib.ql cimport Handle, shared_ptr
from quantlib cimport ql

from engine cimport PricingEngine

from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class DiscountingBondEngine(PricingEngine):

    def __init__(self, YieldTermStructure discount_curve):
        """
        """
        cdef Handle[ql.YieldTermStructure] yts_handle

        if discount_curve.relinkable:
            yts_handle = Handle[ql.YieldTermStructure](
                discount_curve._relinkable_ptr.get().currentLink()
            )
        else:
            yts_handle = Handle[ql.YieldTermStructure](
                discount_curve._thisptr.get()
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.DiscountingBondEngine(yts_handle)
        )
