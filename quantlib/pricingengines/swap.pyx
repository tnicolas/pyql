from cython.operator cimport dereference as deref
 
from quantlib.pricingengines.vanilla.vanilla cimport PricingEngine
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

from quantlib.ql cimport (
    shared_ptr, Handle, _swap as _swap, _pricing_engine as _pe,
    _flat_forward as _ff
)

cdef class DiscountingSwapEngine(PricingEngine):

    def __init__(self, YieldTermStructure ts):

        cdef Handle[_ff.YieldTermStructure] handle = \
            Handle[_ff.YieldTermStructure](deref(ts._thisptr))

        self._thisptr = new shared_ptr[_pe.PricingEngine](
            new _swap.DiscountingSwapEngine(
                handle
            )
        )

