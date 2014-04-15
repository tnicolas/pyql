"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from engine cimport PricingEngine
from quantlib.termstructures.credit.piecewise_default_curve cimport PiecewiseDefaultCurve
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class MidPointCdsEngine(PricingEngine):

    def __init__(self, PiecewiseDefaultCurve ts, double recovery_rate,
                 YieldTermStructure discount_curve):
        """
        First argument should be a DefaultProbabilityTermStructure. Using
        the PiecewiseDefaultCurve at the moment.

        """


        cdef ql.Handle[ql.DefaultProbabilityTermStructure] handle = \
            ql.Handle[ql.DefaultProbabilityTermStructure](deref(ts._thisptr))

        cdef ql.Handle[ql.YieldTermStructure] yts_handle = \
            ql.Handle[ql.YieldTermStructure](deref(discount_curve._thisptr))

        self._thisptr = new shared_ptr[ql.PricingEngine](
            new ql.MidPointCdsEngine(handle, recovery_rate, yts_handle)
        )
