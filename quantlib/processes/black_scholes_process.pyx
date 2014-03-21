from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport Handle, shared_ptr

from quantlib.quotes cimport Quote
from quantlib.termstructures.yields.flat_forward cimport YieldTermStructure
from quantlib.termstructures.volatility.equityfx.black_vol_term_structure cimport BlackVolTermStructure


cdef class GeneralizedBlackScholesProcess:

    def __cinit__(self):
        self._thisptr = NULL

    def __dealloc__(self):
        if self._thisptr is not NULL:
            del self._thisptr

cdef class BlackScholesProcess(GeneralizedBlackScholesProcess):

    def __init__(self, Quote x0, YieldTermStructure risk_free_ts,
                 BlackVolTermStructure black_vol_ts):

        cdef Handle[ql.Quote] x0_handle = Handle[ql.Quote](
            deref(x0._thisptr)
        )
        cdef Handle[ql.YieldTermStructure] risk_free_ts_handle = \
                Handle[ql.YieldTermStructure](
                    deref(risk_free_ts._thisptr)
                )
        cdef Handle[ql.BlackVolTermStructure] black_vol_ts_handle = \
            Handle[ql.BlackVolTermStructure](
                deref(black_vol_ts._thisptr)
            )

        self._thisptr = new shared_ptr[ql.GeneralizedBlackScholesProcess]( new \
            ql.BlackScholesProcess(
                x0_handle,
                risk_free_ts_handle,
                black_vol_ts_handle
            )
        )

cdef class BlackScholesMertonProcess(GeneralizedBlackScholesProcess):

    def __init__(self,
        Quote x0,
        YieldTermStructure dividend_ts,
        YieldTermStructure risk_free_ts,
        BlackVolTermStructure black_vol_ts):

        cdef Handle[ql.Quote] x0_handle = Handle[ql.Quote](
            deref(x0._thisptr)
        )
        cdef Handle[ql.YieldTermStructure] dividend_ts_handle = \
                Handle[ql.YieldTermStructure](
                    deref(dividend_ts._thisptr)
                )
        cdef Handle[ql.YieldTermStructure] risk_free_ts_handle = \
                Handle[ql.YieldTermStructure](
                    deref(risk_free_ts._thisptr)
                )
        cdef Handle[ql.BlackVolTermStructure] black_vol_ts_handle = \
            Handle[ql.BlackVolTermStructure](
                deref(black_vol_ts._thisptr)
            )

        self._thisptr = new shared_ptr[ql.GeneralizedBlackScholesProcess]( new \
            ql.BlackScholesMertonProcess(
                x0_handle,
                dividend_ts_handle,
                risk_free_ts_handle,
                black_vol_ts_handle
            ))
