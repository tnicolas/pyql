from cython.operator cimport dereference as deref

from quantlib.ql cimport shared_ptr
from quantlib cimport ql 

from engine cimport PricingEngine
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class DiscountingSwapEngine(PricingEngine):

    def __init__(self, YieldTermStructure ts):

        cdef ql.Handle[ql.YieldTermStructure] handle = \
            ql.Handle[ql.YieldTermStructure](deref(ts._thisptr))

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.DiscountingSwapEngine(handle)
        )

