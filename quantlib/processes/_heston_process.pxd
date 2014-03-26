"""
 Copyright (C) 2011, Enthought Inc
 Copyright (C) 2011, Patrick Henaff

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 FOR A PARTICULAR PURPOSE.  See the license for more details.
"""
cdef extern from 'ql/processes/hestonprocess.hpp' namespace 'QuantLib::HestonProcess':

    cdef enum Discretization:
        PartialTruncation
        FullTruncation
        Reflection
        NonCentralChiSquareVariance
        QuadraticExponential
        QuadraticExponentialMartingale

cdef extern from 'ql/processes/hestonprocess.hpp' namespace 'QuantLib':

    cdef cppclass HestonProcess:
        HestonProcess() # fake empty constructor for Cython
        # fixme: implement the discrization version of the constructor
        HestonProcess(
            Handle[YieldTermStructure]& riskFreeRate,
            Handle[YieldTermStructure]& dividendYield,
            Handle[Quote]& s0,
            Real v0, Real kappa,
            Real theta, Real sigma, Real rho, Discretization d) except +
            
        Size size() except +
        Real v0() except +
        Real rho() except +
        Real kappa() except +
        Real theta() except +
        Real sigma() except +

        Handle[Quote] s0()
        Handle[YieldTermStructure] dividendYield()
        Handle[YieldTermStructure] riskeFreeRate()

cdef extern from 'ql/processes/batesprocess.hpp' namespace 'QuantLib':

    cdef cppclass BatesProcess(HestonProcess):
        BatesProcess(
            Handle[YieldTermStructure]& riskFreeRate,
            Handle[YieldTermStructure]& dividendYield,
            Handle[Quote]& s0,
            Real v0, Real kappa,
            Real theta, Real sigma, Real rho,
            Real lambda_, Real nu, Real delta, Discretization d) except +

        Real Lambda 'lambda'() except +
        Real nu() except +
        Real delta() except +

