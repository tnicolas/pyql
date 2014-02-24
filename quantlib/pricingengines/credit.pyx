"""
 Copyright (C) 2011, Enthought Inc

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
# distutils: language = c++

from cython.operator cimport dereference as deref

from quantlib.ql cimport (
    Handle, shared_ptr, _pricing_engine as _pe, _credit, 
    _default_term_structure as _dts, _yield_term_structure as _yts
)

from engine cimport PricingEngine
from quantlib.termstructures.credit.piecewise_default_curve cimport PiecewiseDefaultCurve
from quantlib.termstructures.yields.yield_term_structure cimport YieldTermStructure

cdef class MidPointCdsEngine(PricingEngine):

    def __init__(self, PiecewiseDefaultCurve ts, float recovery_rate,
                 YieldTermStructure discount_curve):
        """
        First argument should be a DefaultProbabilityTermStructure. Using
        the PiecewiseDefaultCurve at the moment.

        """


        cdef Handle[_dts.DefaultProbabilityTermStructure] handle = \
            Handle[_dts.DefaultProbabilityTermStructure](deref(ts._thisptr))

        cdef Handle[_yts.YieldTermStructure] yts_handle = \
            Handle[_yts.YieldTermStructure](deref(discount_curve._thisptr))

        self._thisptr = new shared_ptr[_pe.PricingEngine](
            new _credit.MidPointCdsEngine(handle, recovery_rate, yts_handle)
        )
