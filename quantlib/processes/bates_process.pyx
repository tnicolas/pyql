"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""

include '../types.pxi'

from cython.operator cimport dereference as deref

from quantlib cimport ql
from quantlib.ql cimport shared_ptr

from quantlib.quotes cimport Quote, SimpleQuote
from quantlib.termstructures.yields.flat_forward cimport YieldTermStructure
from heston_process cimport HestonProcess

cdef public enum Discretization:
        PARTIALTRUNCATION = ql.PartialTruncation
        FULLTRUNCATION = ql.FullTruncation
        REFLECTION = ql.Reflection
        NONCENTRALCHISQUAREVARIANCE = ql.NonCentralChiSquareVariance
        QUADRATICEXPONENTIAL = ql.QuadraticExponential
        QUADRATICEXPONENTIALMARTINGALE = ql.QuadraticExponentialMartingale

cdef class BatesProcess(HestonProcess):

    def __cinit__(self):
        pass

    def __dealloc(self):
        pass

    def __init__(self,
       YieldTermStructure risk_free_rate_ts=None,
       YieldTermStructure dividend_ts=None,
       Quote s0=None,
       Real v0=0,
       Real kappa=0,
       Real theta=0,
       Real sigma=0,
       Real rho=0,
       Real lambda_=0,
       Real nu=0,
       Real delta=0,
       Discretization d=FULLTRUNCATION,
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
            new ql.BatesProcess(
                risk_free_rate_ts_handle,
                dividend_ts_handle,
                s0_handle,
                v0, kappa, theta, sigma, rho,
                lambda_, nu, delta, d))

    def __str__(self):
        return 'Bates process\nv0: %f kappa: %f theta: %f sigma: %f\nrho: %f lambda: %f nu: %f delta: %f' % \
          (self.v0, self.kappa, self.theta, self.sigma,
           self.rho, self.Lambda, self.nu, self.delta)
    
    property Lambda:
        def __get__(self):
            return (<ql.BatesProcess*> self._thisptr.get()).Lambda()
            
    property nu:
        def __get__(self):
            return (<ql.BatesProcess*> self._thisptr.get()).nu()

    property delta:
        def __get__(self):
            return (<ql.BatesProcess*> self._thisptr.get()).delta()
