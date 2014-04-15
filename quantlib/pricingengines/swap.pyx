from libcpp cimport bool
from cython.operator cimport dereference as deref

from quantlib.ql cimport shared_ptr
from quantlib cimport ql

from quantlib.pricingengines.engine cimport PricingEngine
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure
from quantlib.time.date cimport Date


cdef class DiscountingSwapEngine(PricingEngine):

    def __init__(self, YieldTermStructure discount_curve,
                 bool includeSettlementDateFlows,
                 Date settlementDate,
                 Date npvDate):

        cdef ql.Handle[ql.YieldTermStructure] yts_handle

        if discount_curve.relinkable:
            yts_handle = ql.Handle[ql.YieldTermStructure](
                discount_curve._relinkable_ptr.get().currentLink()
            )
        else:
            yts_handle = ql.Handle[ql.YieldTermStructure](
                discount_curve._thisptr.get()
            )

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.DiscountingSwapEngine(
                yts_handle,
                includeSettlementDateFlows,
                deref(settlementDate._thisptr.get()),
                deref(npvDate._thisptr.get())
            )
        )

