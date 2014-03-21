
#from quantlib.processes._heston_process cimport HestonProcess

cdef extern from 'ql/models/calibrationhelper.hpp' namespace 'QuantLib':

    cdef cppclass CalibrationHelper:
        Volatility impliedVolatility(
            Real targetValue,
            Real accuracy,
            Size maxEvaluation,
            Volatility minVol,
            Volatility maxVol) except +

cdef extern from 'ql/models/calibrationhelper.hpp' namespace 'QuantLib::CalibrationHelper':

    cdef enum CalibrationErrorType:
        RelativePriceError
        PriceError
        ImpliedVolError

cdef extern from 'ql/models/equity/hestonmodelhelper.hpp' namespace 'QuantLib':

    cdef cppclass HestonModelHelper(CalibrationHelper):
        HestonModelHelper(
            Period& maturity,
            Calendar& calendar,
            Real s0,
            Real strikePrice,
            Handle[_qt.Quote]& volatility,
            Handle[YieldTermStructure]& riskFreeRate,
            Handle[YieldTermStructure]& dividendYield,
            CalibrationErrorType errorType
        ) except +
        void setPricingEngine(shared_ptr[PricingEngine]& engine) except +
        Real blackPrice(Real volatility) except +

        ### 'CalibrationHelper' protocol  ###################################
        Real marketValue() except +
        Real modelValue() except +
        Real calibrationError() except +

cdef extern from 'ql/models/equity/hestonmodel.hpp' namespace 'QuantLib':

    cdef cppclass HestonModel:

        HestonModel() # fake empty constructor solving Cython dep. issue
        HestonModel(shared_ptr[HestonProcess]& process)

        shared_ptr[HestonProcess] process() except +
        
        #variance mean reversion level
        Real theta() except +
        #variance mean reversion speed
        Real kappa() except +
        # volatility of the volatility
        Real sigma() except +
        # correlation
        Real rho() except +
        # spot variance
        Real v0() except +

        void calibrate(
               vector[shared_ptr[CalibrationHelper]]&,
               OptimizationMethod& method,
               EndCriteria& endCriteria,
        ) except +



