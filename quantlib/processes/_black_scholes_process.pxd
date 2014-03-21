cdef extern from 'ql/processes/blackscholesprocess.hpp' namespace 'QuantLib':

    cdef cppclass GeneralizedBlackScholesProcess:
        GeneralizedBlackScholesProcess()
        GeneralizedBlackScholesProcess(
            Handle[Quote]& x0,
            Handle[YieldTermStructure]& dividendTS,
            Handle[YieldTermStructure]& riskFreeTS,
            Handle[BlackVolTermStructure]& blackVolTS,
        )

    cdef cppclass BlackScholesProcess(GeneralizedBlackScholesProcess):
        BlackScholesProcess(
            Handle[Quote]& x0,
            Handle[YieldTermStructure]& riskFreeTS,
            Handle[BlackVolTermStructure]& blackVolTS,
        )


    cdef cppclass BlackScholesMertonProcess(GeneralizedBlackScholesProcess):
        BlackScholesMertonProcess(
            Handle[Quote]& x0,
            Handle[YieldTermStructure]& dividendTS,
            Handle[YieldTermStructure]& riskFreeTS,
            Handle[BlackVolTermStructure]& blackVolTS,
        )




