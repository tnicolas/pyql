include '../types.pxi'

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.quotes cimport Quote, SimpleQuote
from quantlib.termstructures.yields.flat_forward cimport YieldTermStructure

cdef public enum Discretization:
        PARTIALTRUNCATION = ql.PartialTruncation
        FULLTRUNCATION = ql.FullTruncation
        REFLECTION = ql.Reflection
        NONCENTRALCHISQUAREVARIANCE = ql.NonCentralChiSquareVariance
        QUADRATICEXPONENTIAL = ql.QuadraticExponential
        QUADRATICEXPONENTIALMARTINGALE = ql.QuadraticExponentialMartingale

cdef class HestonProcess:
    """Heston process: a diffusion process with mean-reverting stochastic variance.

    .. math::
    dS_t &=& (r-d) S_t dt + \sqrt{V_t} S_t dW^s_t \\
    dV_t &=& \kappa (\theta - V_t) dt + \varepsilon \sqrt{V_t} dW^\\upsilon_t \nonumber \\
    dW^s_t dW^\\upsilon_t &=& \rho dt \nonumber

    """


    def __cinit__(self):
        pass

    def __dealloc(self):
        if self._thisptr is not NULL:
            del self._thisptr
            self._thisptr = NULL

    def __init__(self,
       YieldTermStructure risk_free_rate_ts=None,
       YieldTermStructure dividend_ts=None,
       Quote s0=None,
       Real v0=0,
       Real kappa=0,
       Real theta=0,
       Real sigma=0,
       Real rho=0,
       Discretization d=QUADRATICEXPONENTIALMARTINGALE,
       **kwargs):

        if 'noalloc' in kwargs:
            self._thisptr = NULL
            return
        
        #create handles
        cdef ql.Handle[ql.Quote] s0_handle = ql.Handle[ql.Quote](deref(s0._thisptr))
        cdef ql.Handle[ql.YieldTermStructure] dividend_ts_handle = \
                ql.Handle[ql.YieldTermStructure](
                    deref(dividend_ts._thisptr)
                )
        cdef ql.Handle[ql.YieldTermStructure] risk_free_rate_ts_handle = \
                ql.Handle[ql.YieldTermStructure](
                    deref(risk_free_rate_ts._thisptr)
                )

        self._thisptr = new shared_ptr[ql.HestonProcess](
            new ql.HestonProcess(
                risk_free_rate_ts_handle,
                dividend_ts_handle,
                s0_handle,
                v0, kappa, theta, sigma, rho, d
            )
        )

    def __str__(self):
        return 'Heston process\nv0: %f kappa: %f theta: %f sigma: %f rho: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma, self.rho)


    def size(self):
        return self._thisptr.get().size()

    property v0:
        def __get__(self):
            return self._thisptr.get().v0()

    property rho:
        def __get__(self):
            return self._thisptr.get().rho()

    property kappa:
        def __get__(self):
            return self._thisptr.get().kappa()

    property theta:
        def __get__(self):
            return self._thisptr.get().theta()

    property sigma:
        def __get__(self):
            return self._thisptr.get().sigma()

    def s0(self):
        #cdef ql.HestonProcess* hp_ptr = self._thisptr.get()
        cdef ql.Handle[ql.Quote] handle = self._thisptr.get().s0()
        cdef shared_ptr[ql.Quote] quote_sptr = shared_ptr[ql.Quote](handle.currentLink())

        # maybe not optmal but easiest to do
        return  SimpleQuote(quote_sptr.get().value())

